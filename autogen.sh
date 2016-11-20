#!/bin/sh

#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.
#
#  systemd is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with systemd; If not, see <http://www.gnu.org/licenses/>.

set -e

oldpwd=$(pwd)
topdir=$(dirname $0)
cd $topdir

if [ -f .git/hooks/pre-commit.sample ] && [ ! -f .git/hooks/pre-commit ]; then
        # This part is allowed to fail
        cp -p .git/hooks/pre-commit.sample .git/hooks/pre-commit && \
        chmod +x .git/hooks/pre-commit && \
        echo "Activated pre-commit hook." || :
fi

if which gtkdocize >/dev/null 2>/dev/null; then
        if [ ! -d ./docs ]; then
            mkdir ./docs
        fi
        gtkdocize --docdir docs/ --flavour no-tmpl
        gtkdocargs=--enable-gtk-doc
else
        echo "You don't have gtk-doc installed, and thus won't be able to generate the documentation."
        rm -f docs/gtk-doc.make
        echo 'EXTRA_DIST =' > docs/gtk-doc.make
fi

intltoolize --force --automake
autoreconf --force --install --symlink
