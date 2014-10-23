# Installs the the ti-connectiviy wlan firmware files into the root file system

install:
	@if [ ! -d $(DESTDIR) ] ; then \
		echo "The extracted target filesystem directory doesn't exist."; \
		echo "Please run setup.sh in the SDK's root directory and then try again."; \
		exit 1; \
	fi
	install -d  $(DEST_DIR)/lib/firmware/ti-connectivity
	cp *.bin $(DEST_DIR)/lib/firmware/ti-connectivity/

