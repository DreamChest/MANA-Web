# Prophet

Modern, lightweight, responsive, self-hosted RSS reader webapp made with ❤ in France.

#### Disclaimer

Prophet is currently in early phases of development and is highly incomplete and may be buggy. Releases are tested and should be stable enough to be used safely. Please feel free to open an issue to report bugs, crashes or to request features :).

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
