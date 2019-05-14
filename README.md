# Smash Up faction reference generator

This repository houses a small script that gathers factions data off the
[Smash Up wiki](https://smashup.fandom.com/) and generates an easy-to-glance-at
reference to help newcomers choose what factions to play without relying on
advice of their adversaries.

## Requirements

* Ruby, with a configured build toolchain for building native extensions
* libxml2, for nokogiri

## Usage

### Populating existing templates

```sh
bundle install
ruby generate.rb
```

Since the script is really quick&dirty, it doesn't report progress or anything
else at all. But it doesn't take long to run and caches the gathered data for
subsequent runs.

### Creating new templates / modifying existing ones

Nothing fancy, plain ERB (Embedded Ruby) with the only guaranteed variable being
`data` which has the following structure:

```
[ # Top-level is the array of factions
  { # Elements of the array are hashmaps, ont per faction
    name: "Faction Name",
    description: "A brief description of the main features of this faction",
    set: "The Set This Faction Came In",
    icon_data_url: "data:image/png;base64,faction_icon+use_this_in_<img_src="
  }
]
```

The template file needs to have a `erb` file extension, and needs to be in the
same folder, and that's it. The script will place the output into a file named
the same way, but without the `.erb` at the end. It doesn't even have to be
HTML, ERB is pretty flexible.

## Licensing

It didn't take much to build this, so in appreciation of all the effort by
AEG (the developers of the game), Smash Up wiki contributors, and the Wikia
platform that actually hosts the data this project uses, I dedicate any and all
copyright interest in the software to the public domain.

Note that by suggesting your contributions to this repository via pull requests
you are allowing me to include them as dedicated to public domain as well.

The legal-talk is in the `UNLICENSE` file if you're into that :)

Oh. Speaking of pull requests.

## Contribution

I will actually be pleasantly surprised if I ever see an issue or a pull request
in this project, given how niche and low-effort it is. However, rest assured, I
welcome any meaningful input!

## Disclaimer

This repository doesn't include any actual data about the game or derivatives
thereof. The data originates from the
[Smash Up wiki](https://smashup.fandom.com/). Smash Up itself was created by
Paul Peterson and Alderac Entertainment Group (AEG).
