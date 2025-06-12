# BBC Sounds

Show what's currently playing on [BBC Sounds](https://www.bbc.co.uk/sounds) radio stations on Tidbyt

| Current Track                                                            | Programme                                                                  |
| ------------------------------------------------------------------------ | -------------------------------------------------------------------------- |
| ![BBC Radio 1 "Now Playing"](/bbcsounds/gifs/bbc_radio_one-segments-vertical.gif) | ![BBC Radio 1 "Programme"](/bbcsounds/gifs/bbc_radio_one-broadcasts-vertical.gif) |
| ![BBC Radio 2 "Now Playing"](/bbcsounds/gifs/bbc_radio_two-segments-vertical.gif) | ![BBC Radio 2 "Programme"](/bbcsounds/gifs/bbc_radio_two-broadcasts-vertical.gif) |
| ![BBC Radio 3 "Now Playing"](/bbcsounds/gifs/bbc_radio_three-segments-vertical.gif) | ![BBC Radio 3 "Programme"](/bbcsounds/gifs/bbc_radio_three-broadcasts-vertical.gif) |


## Settings

You can change the following settings:

- **BBC Radio Station**: Choose which BBC Radio station to display
- **Display Mode**: Choose what to display: current track details or programme information
- **Scroll direction**: Choose whether to scroll text horizontally or vertically
- **Scroll speed**: Slow down the scroll speed of the text

## Supported Stations

- **BBC Radio 1** - Pop and contemporary music
- **BBC Radio 1Xtra** - Hip hop, R&B, and UK urban music
- **BBC Radio 2** - Adult contemporary and popular music
- **BBC Radio 3** - Classical music and arts
- **BBC Radio 3 Unwind** - Relaxing ambient and classical music
- **BBC Radio 4** - News, current affairs, and speech
- **BBC Radio 4 Extra** - Archive comedy, drama, and entertainment
- **BBC Radio 5 Live** - News and sports
- **BBC Radio 5 Sports Extra** - Extended sports coverage
- **BBC Radio 6 Music** - Alternative and indie music
- **BBC Asian Network** - Music and programming for Asian communities
- **BBC World Service** - International news and programming
- **BBC Radio Scotland** - Scottish programming
- **BBC Radio Ulster** - Northern Ireland programming
- **BBC Radio Wales** - Welsh programming in English
- **BBC Radio Cymru** - Welsh programming in Welsh

Each station displays with its official BBC brand colors in the header.

## Features

- **Multi-Station Support**: Choose from 15 major BBC Radio stations
- **Station-Branded Colors**: Each station displays with its official BBC brand colors
- **Two Display Modes**:
  - **Current Track**: Shows details of the currently playing music/content
  - **Programme**: Shows current programme information
- **Smart Fallback**: When track details aren't available, automatically falls back to programme information
- **Live Data**: Updates every 30 seconds from BBC's live APIs

## Development

Use VS Code Task **Pixlet: Serve** and select `bbcsounds` to get started, then open `http://127.0.0.1:8080` in the browser to see the Pixlet output.

I have some mock responses from BBC Sounds in the [`mocks`](/bbcsounds/mocks) folder that can be used with Pixlet by running the **Mocks: Start server** VS Code task and selecting `bbcsounds`, then uncommenting the appropriate endpoint lines in the main [bbcsounds.star](/bbcsounds/gifs/bbcsounds.star) file.

## Technical Details

The app uses BBC's official Radio & Music Services (RMS) API:
- Segments API: `https://rms.api.bbc.co.uk/v2/services/{service_id}/segments/latest`
- Broadcasts API: `https://rms.api.bbc.co.uk/v2/broadcasts/latest?service={service_id}&on_air=now`
