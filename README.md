# SwiftTar

[![MIT License][license-badge]][license]

Extract TAR files in memory on iOS.

---

This library is just a re-packaged subset of the
[SWCompression](https://github.com/tsolomko/SWCompression/) library.
`SWCompression/TAR` provides a great implementation of a TAR file parser,
but was overkill for including in my app just to parse TAR files.

This library also has a script that will bundle all sources as a single file
and make the access level internal so it can be more easily bundled in consuming
applications or frameworks without requiring a Cocoapod/module dependency.

---

## License

Released under the [MIT License](LICENSE).

[license]: LICENSE
[license-badge]: https://img.shields.io/github/license/mrosales/SwiftTar?style=flat-square
