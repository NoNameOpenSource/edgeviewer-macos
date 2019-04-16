# EdgeViewer-macOS
## Contents
1. [Overview](#overview)
2. [Plugins](#plugins)
3. [Building](#building)
4. [License](#license)

<a name="overview"></a>
## Overview
EdgeViewer is an open source application that aims to be a universal viewer for Manga and other comic book-like content. EdgeViewer comes out of the box with support for locally-stored content, but you can add plugins written in JavaScript to bring in content from other sources. See the [Plugins](#plugins) section for more information.

<a name="plugins"></a>
## Plugins
EdgeViewer provides a simple mechanism for installing plugins written in JavaScript that seamlessly integrate with the rest of the application. Though we do not officially support or endorse any third-party plugins, EdgeViewer cannot thrive without an active community of plugin creators. 
[//]: # "Only EdgeViewer's central codebase is hosted on our GitHub account, but a full list of unsupported plugins is available at on our [EdgeViewer Third-Party Plugins](https://ggomong.com/edgeviewer/plugins) page."
To connect with us about creating a plugin, contact us at [contributions@ggomong.com](mailto:contributions@ggomong.com).

<a name="building"></a>
## Building
1. Use `carthage update` to dowload necessary framework data.
2. Build with Xcode.

<a name="license"></a>
## License
EdgeViewer for macOS is licensed with the [LGPL License](https://www.gnu.org/licenses/lgpl-3.0.en.html).
