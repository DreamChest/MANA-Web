# Prophet

Modern, lightweight, responsive, self-hosted RSS reader webapp made with ❤ in France.

**DISCLAIMER**: This is the old ("legacy") version of Prophet which will no longer be maintained. The last release for this version is the [0.3.1](https://github.com/DreamChest/Prophet/releases/tag/0.3.1). For the new version, see the [master branch](https://github.com/DreamChest/Prophet/tree/master) and all releases above 1.0.

## Features

- [x] Functional entries, sources and tags
- [x] Entry preview
- [x] Entry filtering by source or tag
- [x] Dynamically loaded page (no redirect)
- [ ] Fully responsive UI (about 90% responsive since the current design is far from final)
- [x] Localized UI
	- [x] English
	- [x] French
	- [ ] Other (will need contributors)

## Getting started

### Environment

- Ruby 2.4.x
- Ruby on Rails 5.1.1
- Any [ExecJS](https://github.com/rails/execjs) supported Javascript runtime
- ImageMagick 6.4.9 (or at least MagickCore and MagickWand libs)

### Quickstart

1. `git clone https://github.com/DreamChest/Prophet && cd Prophet`
2. `bundle install`
3. `./prophet start`

Prophet will run in background, to stop it: `./prophet stop`

## Licence

[See LICENSE](https://github.com/DreamChest/Prophet/blob/master/LICENSE)
