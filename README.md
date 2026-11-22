# Afrim Data Repository

![Latest afrim compatibility](https://github.com/pythonbrad/afrim-data/actions/workflows/check.yml/badge.svg)

*All language codes should follows as possible the [ISO 639-3](https://iso639-3.sil.org).*

## [Medumba](byv)
Configuration for the Medumba input method.
- Dictionary of Medumba words

## [Clafrica](clafrica)
Configuration for the Clafrica input method based on the Clafrica code of Resulam. 
- Clafrica code for single characters
- Clafrica code for double characters

## [Nufi](fmp)
Clafrica extension for the Nufi language. 
- Nufi SMS
- Date translator
- Numerals translator

## [Ethiopic](ethiopic)
Configuration for the Ethiopic input method. 
- Ethiopic code

## [Ewondo](ewo)
Configuration for the Ewondo input method.
- Dictionary of Ewondo words

## [Geez](gez)
Configuration for the Geez input method. 
- Geez code
- Geez punctuations
- Numerals translators

## [GeezIME](geezime)
Configuration for the Geez input method version of [EriLingual Solutions](https://geez-ime.vercel.app/).

## [Amharic](am)
Configuration for the Amharic input method. 
- Amharic code
- Dictionary of Amharic names
- Dictionary of frequently used Amharic words
- Date translator

## [Bamun](bax)
Configuration for the Bamun input method.

## [Vietnam](vie)
Configuration for the Vietnam input method.

## Web access
The datasets are published on GitHub Pages by the [Pages workflow](.github/workflows/pages.yml).
Every `*.toml` file is gzipped to reduce its size, and other files (e.g. `*.rhai` scripts) are served unchanged.

- URL format: `https://fodydev.github.io/afrim-data/<lang>/<file>.toml.gz` (e.g. [`am/am.toml.gz`](https://fodydev.github.io/afrim-data/am/am.toml.gz))
- Relative `.toml` paths inside a configuration must be resolved by appending `.gz`.
- [`datasets.json`](https://fodydev.github.io/afrim-data/datasets.json) lists the available datasets (`name`, `description`, `version`, root `dir` and main `config` path).
- [`index.json`](https://fodydev.github.io/afrim-data/index.json) lists all published files.
