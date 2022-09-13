TEMPLATE = aux

INSTALLER = installer

OUTPUT = D:\Development\CPMap\cp-map-installer.exe
INPUT = $$shell_quote($$shell_path($$PWD))/config/config.xml
INPUT += $$PWD/packages/com.paipeng.cpmap/meta/package.xml
INPUT += $$PWD/packages/com.paipeng.cpmap/meta/installscript.qs
INPUT += $$PWD/packages/com.paipeng.cpmap/meta/LICENSE.txt
INPUT += $$PWD/packages/com.paipeng.cpmap.installer/meta/package.xml
#INPUT += $$PWD/packages/com.microsoft.redistubution/meta/package.xml
#INPUT += $$PWD/packages/com.microsoft.redistubution/meta/installscript.qs

example.input = INPUT
example.output = $$INSTALLER
example.commands = C:\Qt\QtIFW-4.4.1\bin\binarycreator -c $$shell_quote($$shell_path($$PWD))\config\config.xml -p $$shell_quote($$shell_path($$PWD))\packages $$OUTPUT -v
#${QMAKE_FILE_OUT}
example.CONFIG += target_predeps no_link combine

QMAKE_EXTRA_COMPILERS += example

OTHER_FILES = README
