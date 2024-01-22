# =================================================================================================
# Copyright (C) 2016-2018 University of Glasgow
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# SPDX-License-Identifier: BSD-2-Clause
# =================================================================================================
# Configuration for make itself:

# Warn if the Makefile references undefined variables and remove built-in rules:
MAKEFLAGS += --output-sync --warn-undefined-variables --no-builtin-rules --no-builtin-variables

# Remove output of failed commands, to avoid confusing later runs of make:
.DELETE_ON_ERROR:

# Remove obsolete old-style default suffix rules:
.SUFFIXES:

# List of targets that don't represent files:
.PHONY: all clean

# =================================================================================================

# The PDF files to build, each should have a corresponding .tex file:
PDF_FILES = draft-mcquistin-abstract-data-model.pdf

# The TXT files to build, each should have a corresponding RFCv3 XML file:
TXT_FILES = draft-mcquistin-abstract-data-model.txt

# Master build rule:
all: $(PDF_FILES) $(TXT_FILES)

%.pdf: %.txt
	enscript -q -lc -f Courier11 -M A4 -p - $< | ps2pdf - $@

%.txt: %.xml
	xml2rfc --text --v3 $<
	@egrep -ns --colour "\\bmust|required|shall|should|recommended|may|optional|FIXME\\b" $< || true

# =================================================================================================
# Rules to clean-up.

define xargs
$(if $(2),$(1) $(wordlist 1,1000,$(2)))
$(if $(word 1001,$(2)),$(call xargs,$(1),$(wordlist 1001,$(words $(2)),$(2))))
endef

define rm
$(call xargs,rm -f ,$(1))
endef

define rmdir
$(call xargs,rm -fr ,$(1))
endef

clean:
	$(call rm,$(PDF_FILES))
	$(call rm,$(TXT_FILES))

# =================================================================================================
# vim: set ts=2 sw=2 tw=0 ai:
