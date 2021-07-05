PREFIX ?= /usr/share/sddm/themes/

all:
	@echo Run \'make install\' to install sddm-endeavour.

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/sddm-endeavour
	@cp -pr * $(DESTDIR)$(PREFIX)/sddm-endeavour
	@chmod 755 $(DESTDIR)$(PREFIX)/sddm-endeavour

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/sddm-endeavour
