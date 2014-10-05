COFFEE=$(CURDIR)/node_modules/coffee-script/bin/coffee
INSTALL_DIR = cp -f -R
INSTALL_FILE = install -m 644 -p

all: coffee gencert npm_rebuild

install: strip_deps
	@test -d $(INSTALL_ROOT)/usr/share/harmony-server || mkdir -p $(INSTALL_ROOT)/usr/share/harmony-server
	$(INSTALL_DIR) node_modules $(INSTALL_ROOT)/usr/share/harmony-server
	$(INSTALL_DIR) public $(INSTALL_ROOT)/usr/share/harmony-server
	$(INSTALL_DIR) ssl $(INSTALL_ROOT)/usr/share/harmony-server
	$(INSTALL_FILE) *.js $(INSTALL_ROOT)/usr/share/harmony-server
	

coffee: coffeeroot coffeepublic

coffeeroot:
	$(COFFEE) -c *.coffee
coffeepublic:
	cd $(CURDIR)/public/js && $(COFFEE) -c *.coffee
	
clean: cleanjsroot cleanjspublic

cleanjsroot:
	rm -f *.js

cleanjspublic:
	cd $(CURDIR)/public/js && rm -f *.js

npm:
	npm install
	cd $(CURDIR)/node_modules && ./cleanup.sh

strip_deps:
	cd $(CURDIR)/node_modules && ./strip.sh

npm_rebuild:
	#-npm rebuild
	cd $(CURDIR)/node_modules/websocket && /usr/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js rebuild

gencert:
	./gencert.sh