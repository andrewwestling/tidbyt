# BBC Radio 3

Show what's currently playing on [BBC Radio 3](https://bbc.co.uk/radio3) on Tidbyt

| Current Track                                               | Programme                                               |
| -------------------------------------------------------- | ------------------------------------------------------ |
![BBC Radio 3 "Now Playing"](/bbcradio3/bbcradio3-segments-vertical.gif) |  ![BBC Radio 3 "Now Playing"](/bbcradio3/bbcradio3-broadcasts-vertical.gif) |


## Settings

You can change the following settings:

- **Display Mode**: Choose what information to display:
  - **Show Current Track**: Displays the currently playing piece with composer and title details (uses BBC's Segments API for real-time track information)
  - **Show Programme**: Shows the current programme name and episode title/description (uses BBC's Broadcasts API for programme-level information)
- **Scroll direction**: Choose whether to scroll text horizontally or vertically
- **Scroll speed**: Slow down the scroll speed of the text
- **Use custom colors**: Choose your own text colors
  - **Color: Title**: Choose your own color for the title of the current piece/programme
  - **Color: Composer**: Choose your own color for the composer/programme details

## Display Modes Explained

**Show Current Track Mode**: Perfect for when you want to see exactly what piece of classical music is playing right now. Shows composer names and specific work titles as they change throughout a programme.

**Show Programme Mode**: Ideal for getting an overview of what's currently on BBC Radio 3. Shows programme names like "Radio 3 in Concert", "Afternoon Concert", or "In Tune" along with episode descriptions.

## Development

Use VS Code Task **Pixlet: Serve** and select `bbcradio3` to get started, then open `http://127.0.0.1:8080` in the browser to see the Pixlet output.

I have some mock responses from BBC Radio 3 in the [`mocks`](/bbcradio3/mocks) folder that can be used with Pixlet by running the **Mocks: Start server** VS Code task and selecting `bbcradio3`, then uncommenting the appropriate endpoint lines in the main [bbcradio3.star](/bbcradio3/bbcradio3.star) file.

### Mock Data Structure

- [`mocks/segments/`](/bbcradio3/mocks/segments) - Mock data for the Segments API (current track details)
  - `short-song-title.json` - Example with short piece title
  - `long-song-title.json` - Example with long piece title
  - `404.json` - Error response for testing
- [`mocks/broadcasts/`](/bbcradio3/mocks/broadcasts) - Mock data for the Broadcasts API (programme information)
  - `concert-programme.json` - Example concert programme
  - `regular-programme.json` - Example regular programme
  - `404.json` - Error response for testing
