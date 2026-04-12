# Flat-File-DB
Flat File DB is a browser-based, schema-driven, human-readable database system that stores records as text files while supporting relational structures through folders and metadata.  This project is designed around transparency, resilience, and user ownership of data.

## Overview

Flat File DB is a browser-based, schema-driven, human-readable database system that stores records as text files while supporting relational structures through folders and metadata.

This project is designed around transparency, resilience, and user ownership of data.

---

## Key Features

* Human-readable record storage (text/markdown-like format)
* Folder-based relational structure
* Schema-driven dynamic forms
* Table types:

  * Normal
  * Shared (global lookup tables)
  * Child (relational sub-tables)
* Drop-down relationships between tables
* Auto-save with change detection
* Search with normalized text handling (handles word wrapping issues)
* Link field support (web + file references)
* Exportable records and manifests

---

## Philosophy

Flat File DB is built on a few core ideas:

* Data should be readable without special tools
* Users should own their data
* Systems should degrade gracefully
* Structure should emerge from simple primitives

---

## Lineage

This project is the continuation of a long-running idea:

* **Gear-Up 1.0 (2001)**
  Turbo Basic / MS-DOS application with ~3,000 downloads

* **Intuitus (unreleased)**
  Conceptual successor focusing on flexible schemas and better text handling

* **Flat File DB (current)**
  Modern browser-based realization of those ideas

---

## Development Model

This system was created through **cognitive co-development** between:

* Michel Kasday (architecture, design, domain logic)
* ChatGPT (OpenAI) (implementation support, iteration acceleration)

This represents a human-guided, extra-biological collaborative development process.

---

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0).

---

## Getting Started

1. Open the HTML file in a modern browser
2. Define a table schema
3. Create records
4. Optionally connect to a local folder for persistent storage

---

# Development History

## Gear-Up 1.0 (2000–2001)

* Built in Turbo Basic
* Ran on MS-DOS 6.22
* Developed on a 286 laptop
* Designed for floppy disk constraints
* Fixed schema structure
* External help screens via batch files
* ~3,000 downloads on freeware sites

The author maintained responsibility for users, including keeping support contact available.

---

## Intuitus (Concept Phase)

Designed to address limitations of Gear-Up:

* Rigid schema
* Limited editing (line replacement instead of inline editing)
* No true notes/long text support
* Search failures due to word wrapping

Introduced ideas:

* Flexible schema
* Better text handling
* More dynamic data relationships

---

## Flat File DB

Realization of the original vision using modern tools:

* Browser-based interface
* Dynamic schema generation
* Folder-based relational structure
* Shared tables for reuse
* Child tables for one-to-many relationships
* Readable text records with metadata
* Linked-list style record recovery concept
* Improved search handling word wrapping

---

## Future Directions

* File-system aware link resolution
* Visualization of relationships
* Schema evolution tools
* Versioning and recovery enhancements

---

## Closing Note

This system represents the continuation of an idea developed over more than two decades, now realized through modern collaborative tools and human–EBI interaction.
