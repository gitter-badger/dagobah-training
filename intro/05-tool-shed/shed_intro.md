layout: true
class: inverse, middle, large

---
class: special
# The Galaxy Tool Shed
intro to 'shed'

slides by @martenson

.footnote[\#usegalaxy / @galaxyproject]

---
class: larger

## Please Interrupt!

We are here to answer your questions.

---

Tool Shed is to Galaxy as App Store is to iPhone (plus some more).

It is a free service that hosts repositories containing Galaxy Tools.

---
Main Tool Shed (MTS) runs at http://toolshed.g2.bx.psu.edu and serves all Galaxies worldwide.

Everybody can create a repository.

Every repository is public including the whole history.

Local sheds can be run e.g. for private or custom-licensed tools.

???
Running local TS is discouraged.

---
## Vocabulary

* `wrapper` or `tool definition file` - The XML file that describes to Galaxy how the underlying software works, thus allowing Galaxy to render UI and execute the software in the right way.
--

* `repository` - A versioned code archive with tool(s) in Tool Shed. Mercurial is used.
--

* `revision` vs `installable revision` - Every TS repo update generates a new revision but only certain (reproducibility-affecting) changes generate a new revision installable to Galaxy.
--

* `metadata` - TS generates and stores a set of data for every installable revision of the repo.

???
Every TS repo update can be propagated to the Galaxy though.

---
## Overview

* Tool Shed is a host (not a development) platform.
--

* Tool Development repository should be linked from the TS repository.
--

* Tool Shed allows administrators to pick any installable revision
--

* Multiple installable revisions of any repository can be present in Galaxy

---
## Galaxy's Configuration

List of available sheds is defined in `tool_sheds_conf.xml` and Galaxy comes with the Main Tool Shed enabled and the TTS disabled.
```
<?xml version="1.0"?>
<tool_sheds>
    <tool_shed name="Galaxy Main Tool Shed" url="https://toolshed.g2.bx.psu.edu/"/>
<!-- Test Tool Shed should be used only for testing purposes.
    <tool_shed name="Galaxy Test Tool Shed" url="https://testtoolshed.g2.bx.psu.edu/"/>
-->
</tool_sheds>
```

---
## Simple repository
tool remove_beginning
repository = script + wrapper + test data + metadata file

```
.
├── .shed.yml
├── remove_beginning.pl
├── remove_beginning.xml
└── test-data
    ├── 1.bed
    └── eq-removebeginning.dat

```

---
class: normal

### .shed.yml file

a file with metadata

```
categories:
- Text Manipulation
description: Remove lines from the beginning of a file.
long_description: |
  This tool removes the specified number of lines from the beginning
  of the input dataset.
name: remove_beginning
owner: devteam
remote_repository_url: https://github.com/galaxyproject/tools-devteam/tree/master/tools/remove_beginning
type: unrestricted
```

---
class: normal

## Repository & tool with requirements
seqtk repository with multiple tools

```
.
├── .shed.yml
├── macros.xml
├── seqtk_comp.xml
├── seqtk_sample.xml
├── seqtk_seq.xml
├── seqtk_trimfq.xml
├── test-data
│   ├── seqtk_trimfq.fq
...
│   ├── seqtk_trimfq_be.fq
│   └── seqtk_trimfq_default.fq
└── tool_dependencies.xml
```

---
### seqtk requirements
Requirements of the wrapper.

```
<requirements>
    <requirement type="package" version="1.2">seqtk</requirement>
</requirements>
```

Galaxy is aiming to be resolution-agnostic.
---

### seqtk tool_dependencies.xml file
A TS way to fulfill requirements.

```
<?xml version="1.0"?>
<tool_dependency>
  <package name="seqtk" version="1.2">
    <repository name="package_seqtk_1_2" owner="iuc"/>
  </package>
</tool_dependency>
```

---
class: normal

### seqtk TS package
A TS recipe how to install the dependency.
```
<?xml version="1.0"?>
<tool_dependency>
    <package name="seqtk" version="1.0-r75-dirty">
        <install version="1.0">
            <actions>
                <action type="shell_command">git clone https://github.com/lh3/seqtk/ seqtk</action>
                <action type="shell_command">git reset --hard 08b3625c2a7aae3eca9ab056e1adea52ec22cbef</action>
                <action type="shell_command">make</action>
                <action type="move_file">
                    <source>seqtk</source>
                    <destination>$INSTALL_DIR/bin</destination>
                </action>
                <action type="set_environment">
                  <environment_variable action="prepend_to" name="PATH">$INSTALL_DIR/bin/</environment_variable>
                </action>
            </actions>
        </install>
    </package>
</tool_dependency>
```

---
class: normal

### seqtk Conda package
Conda recipe how to install the dependency.

```
package:
  name: seqtk
  version: 1.2

source:
  fn: v1.2.tar.gz
  url: https://github.com/lh3/seqtk/archive/v1.2.tar.gz

build:
  number: 0
  skip: False

requirements:
  build:
    - gcc   # [not osx]
    - llvm  # [osx]
    - zlib
  run:
    - zlib

about:
  home: https://github.com/lh3/seqtk
  license: MIT License
  summary: Seqtk is a fast and lightweight tool for processing sequences in the FASTA or FASTQ format

test:
  commands:
    - seqtk seq
```

---
###
