DOCDIR=/usr/doc/mtpaint

install:
	mkdir -p $(DOCDIR)
	cp -r docs/* $(DOCDIR)

uninstall:
	rm -rf $(DOCDIR)
