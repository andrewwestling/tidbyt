"""
Applet: BBC Radio 3
Summary: BBC Radio 3 What's On
Description: Shows what's currently playing on BBC Radio 3, the UK's Classical Music Radio Station.
Author: Andrew Westling
"""

load("http.star", "http")
load("render.star", "render")
load("schema.star", "schema")

SEGMENTS_ENDPOINT = "https://rms.api.bbc.co.uk/v2/services/bbc_radio_three/segments/latest"
BROADCASTS_ENDPOINT = "https://rms.api.bbc.co.uk/v2/broadcasts/latest?service=bbc_radio_three&on_air=now"

COLORS = {
    "dark_red": "#8B0000",
    "medium_red": "#DC143C",
    "light_red": "#FF6B6B",
    "white": "#FFFFFF",
    "light_gray": "#AAAAAA",
    "medium_gray": "#888888",
    "dark_gray": "#444444",
    "error_red": "#FF0000",
}

DISPLAY_MODE_OPTIONS = [
    schema.Option(
        display = "Show Current Track",
        value = "segments",
    ),
    schema.Option(
        display = "Show Programme",
        value = "broadcasts",
    ),
]

SCROLL_DIRECTION_OPTIONS = [
    schema.Option(
        display = "Vertical",
        value = "vertical",
    ),
    schema.Option(
        display = "Horizontal",
        value = "horizontal",
    ),
]

SCROLL_SPEED_OPTIONS = [
    schema.Option(
        display = "Fast",
        value = "0",
    ),
    schema.Option(
        display = "Slower",
        value = "100",
    ),
    schema.Option(
        display = "Slowest",
        value = "200",
    ),
]

DEFAULT_DISPLAY_MODE = DISPLAY_MODE_OPTIONS[0].value
DEFAULT_SCROLL_DIRECTION = SCROLL_DIRECTION_OPTIONS[0].value
DEFAULT_SCROLL_SPEED = SCROLL_SPEED_OPTIONS[0].value
DEFAULT_USE_CUSTOM_COLORS = False
DEFAULT_COLOR_TITLE = COLORS["light_red"]
DEFAULT_COLOR_DETAILS = COLORS["white"]

RED_HEADER_BAR = render.Stack(
    children = [
        render.Box(width = 64, height = 5, color = COLORS["dark_red"]),
        render.Text(content = "BBC Radio 3", height = 6, font = "tom-thumb"),
    ],
)

ERROR_CONTENT = render.Column(
    expanded = True,
    main_align = "space_around",
    children = [
        render.Marquee(width = 64, child = render.Text(content = "Can't connect to BBC Radio 3 :(", color = COLORS["error_red"])),
    ],
)

def main(config):
    # Get settings values
    display_mode = config.str("display_mode", DEFAULT_DISPLAY_MODE)
    scroll_direction = config.str("scroll_direction", DEFAULT_SCROLL_DIRECTION)
    scroll_speed = int(config.str("scroll_speed", DEFAULT_SCROLL_SPEED))
    use_custom_colors = config.bool("use_custom_colors", DEFAULT_USE_CUSTOM_COLORS)

    # Choose endpoint based on display mode
    if display_mode == "broadcasts":
        endpoint = BROADCASTS_ENDPOINT
        # Test data (run the "Mocks: Start server" VS Code task then uncomment a line below to test):
        # endpoint = "http://localhost:61010/broadcasts/concert-programme.json" # Concert programme
        # endpoint = "http://localhost:61010/broadcasts/regular-programme.json" # Regular programme
        # endpoint = "http://localhost:61010/broadcasts/404.json" # To test "Can't connect"

    else:
        endpoint = SEGMENTS_ENDPOINT
        # Test data (run the "Mocks: Start server" VS Code task then uncomment a line below to test):
        # endpoint = "http://localhost:61010/segments/long-song-title.json" # Long song title
        # endpoint = "http://localhost:61010/segments/short-song-title.json" # Short piece title
        # endpoint = "http://localhost:61010/segments/404.json" # To test "Can't connect"

    # Get data
    whats_on = http.get(url = endpoint, ttl_seconds = 30)

    if (whats_on.status_code) != 200:
        return render.Root(
            child = render.Column(
                children = [
                    RED_HEADER_BAR,
                    ERROR_CONTENT,
                ],
            ),
        )

    # Parse data
    data = whats_on.json()
    has_data = data and "data" in data and len(data["data"]) > 0

    title = ""
    composer = ""

    if has_data:
        if display_mode == "broadcasts":
            # Handle broadcast data
            broadcast = data["data"][0]
            programme = broadcast.get("programme", {})
            titles = programme.get("titles", {})

            # For broadcasts, use primary (programme name) and secondary (episode title)
            title = titles.get("primary", "") or ""
            composer = titles.get("secondary", "") or ""

            # If no secondary title, use synopsis short as subtitle
            if not composer:
                synopses = programme.get("synopses", {})
                composer = synopses.get("short", "") or ""
        else:
            # Handle segments data (existing logic)
            # Find the currently playing item
            current_item = None
            for item in data["data"]:
                if item.get("offset", {}).get("now_playing", False):
                    current_item = item
                    break

            # If no currently playing item found, use the first one
            if not current_item and len(data["data"]) > 0:
                current_item = data["data"][0]

            if current_item:
                # Handle both music and speech segments
                titles = current_item.get("titles", {})

                if current_item.get("segment_type") == "music":
                    # For music: primary is usually composer, secondary is piece title
                    composer = titles.get("primary", "") or ""
                    title = titles.get("secondary", "") or ""

                    # If no secondary title, use primary as title and clear composer
                    if not title and composer:
                        title = composer
                        composer = ""
                elif current_item.get("segment_type") == "speech":
                    # For speech segments: use primary as title, secondary as subtitle/description
                    title = titles.get("primary", "") or ""
                    composer = titles.get("secondary", "") or ""
                else:
                    # Fallback for unknown segment types
                    title = titles.get("primary", "") or titles.get("secondary", "") or ""
                    composer = ""

    # Handle colors
    if use_custom_colors:
        color_title = config.str("color_title", DEFAULT_COLOR_TITLE)
        color_details = config.str("color_details", DEFAULT_COLOR_DETAILS)
    else:
        color_title = DEFAULT_COLOR_TITLE
        color_details = DEFAULT_COLOR_DETAILS

    # These are just for putting the content into
    root_contents = None
    data_parts = []

    # Vertical scrolling
    if scroll_direction == "vertical":
        # For vertical mode, each child needs to be a WrappedText widget, so the text will wrap to the next line

        # (I also wrap each child in a Padding widget with appropriate spacing, so things can breathe a little bit)
        pad = (0, 4, 0, 0)  # (left, top, right, bottom)

        if title:
            # Don't pad the top one because it doesn't need it
            data_parts.append(render.Padding(pad = 0, child = render.WrappedText(align = "center", width = 64, content = title, font = "tb-8", color = color_title)))
        if composer:
            data_parts.append(render.Padding(pad = pad, child = render.WrappedText(align = "center", width = 64, content = composer, font = "tom-thumb", color = color_details)))

        root_contents = render.Marquee(
            scroll_direction = "vertical",
            height = 27,
            child = render.Column(children = data_parts),
        )

    # Horizontal scrolling
    if scroll_direction == "horizontal":
        # For horizontal mode, each child needs to be its own Marquee widget, so each line will scroll individually when too long
        if title:
            data_parts.append(render.Marquee(width = 64, child = render.Text(content = title, font = "tb-8", color = color_title)))
        if composer:
            data_parts.append(render.Marquee(width = 64, child = render.Text(content = composer, font = "tom-thumb", color = color_details)))

        root_contents = render.Column(
            expanded = True,
            main_align = "space_evenly",
            children = data_parts,
        )

    return render.Root(
        delay = scroll_speed,
        child = render.Column(
            children = [
                RED_HEADER_BAR,
                root_contents,
            ],
        ),
    )

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Dropdown(
                id = "display_mode",
                name = "Display Mode",
                desc = "Choose what to display: current track details or programme information",
                icon = "radio",
                options = DISPLAY_MODE_OPTIONS,
                default = DEFAULT_DISPLAY_MODE,
            ),
            schema.Dropdown(
                id = "scroll_direction",
                name = "Scroll direction",
                desc = "Choose whether to scroll text horizontally or vertically",
                icon = "alignJustify",
                options = SCROLL_DIRECTION_OPTIONS,
                default = DEFAULT_SCROLL_DIRECTION,
            ),
            schema.Dropdown(
                id = "scroll_speed",
                name = "Scroll speed",
                desc = "Slow down the scroll speed of the text",
                icon = "gauge",
                options = SCROLL_SPEED_OPTIONS,
                default = DEFAULT_SCROLL_SPEED,
            ),
            schema.Toggle(
                id = "use_custom_colors",
                name = "Use custom colors",
                desc = "Choose your own text colors",
                icon = "palette",
                default = DEFAULT_USE_CUSTOM_COLORS,
            ),
            schema.Generated(
                id = "custom_colors",
                source = "use_custom_colors",
                handler = custom_colors,
            ),
        ],
    )

def custom_colors(use_custom_colors):
    if use_custom_colors == "true":  # Not a real Boolean, it's a string!
        return [
            schema.Color(
                id = "color_title",
                name = "Color: Title",
                desc = "Choose your own color for the title of the current piece",
                icon = "palette",
                default = DEFAULT_COLOR_TITLE,
                palette = [
                    COLORS["white"],
                    COLORS["light_red"],
                    COLORS["medium_red"],
                ],
            ),
            schema.Color(
                id = "color_details",
                name = "Color: Details",
                desc = "Choose your own color for the details of the current piece or programme",
                icon = "palette",
                default = DEFAULT_COLOR_DETAILS,
                palette = [
                    COLORS["white"],
                    COLORS["light_red"],
                    COLORS["medium_red"],
                    COLORS["dark_red"],
                ],
            ),
        ]
    else:
        return []
