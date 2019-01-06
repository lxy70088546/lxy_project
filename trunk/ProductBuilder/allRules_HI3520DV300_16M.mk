include $(TOP_DIR)/ProductBuilder/PathDefinition
include $(SOURCE_DIR)/Build/version

WORK_Dir_BasName=$(shell basename $(WORK_DIR))
WORK_Dir_NeedName=ProductBuilder

ifndef WORK_DIR
WORK_DIR=/home/share/Error/ProductBuilder
endif

ifndef OBJS_DIR
    OBJS_DIR := $(WORK_DIR)
endif

# 代码分支名称
ifndef MAKE_DIR
    MAKE_DIR:=$(shell basename $(shell pwd))
endif

ifndef WIFI_MODULE
	WIFI_MODULE=mt7601Usta
endif

ifndef PICSUP
PICSUP=$(shell basename $(shell dirname $(shell pwd)))
endif

ifndef EXTRA_PRODUCT_TYPE
EXTRA_PRODUCT_TYPE=$(shell basename $(shell pwd))
endif

ifndef PICSUPUP
PICSUPUP=$(shell basename $(shell dirname $(shell dirname $(shell pwd))))
endif

ifndef GUI_VENDOR
GUI_VENDOR=$(PICSUPUP)
endif

ifndef OEM_VENDOR
OEM_VENDOR=$(PICSUP)
endif

ifndef OEM_VENDOR_DIR
OEM_VENDOR_DIR=$(shell basename $(shell dirname $(shell pwd)))
endif

ifndef GUI_STRING_PATH
GUI_STRING_PATH=$(shell basename $(shell dirname $(shell dirname $(shell pwd))))
endif 

ifndef OEM_STRING_PATH
OEM_STRING_PATH=$(shell basename $(shell dirname $(shell pwd)))
endif 

#修改OEM_WEB 为web/config下配置，OEM_WEB_HTML为web下面web/html下面配置，OEM_WEB_CAB为web/web.cab下面cab包
ifndef USE_WEB_NOOCX

ifndef OEM_WEB
OEM_WEB_CONFIG=$(PICSUP)
OEM_WEB_HTML=$(PICSUP)
OEM_WEB_CAB=$(PICSUP)
else
ifndef OEM_WEB_CONFIG
OEM_WEB_CONFIG=$(OEM_WEB)
endif
ifndef OEM_WEB_HTML
OEM_WEB_HTML=$(OEM_WEB)
endif
ifndef OEM_WEB_CAB
OEM_WEB_CAB=$(OEM_WEB)
endif
endif
ifeq ($(VERSION_FIX), R12)
OEM_WEB_CONFIG=General
OEM_WEB_HTML=General
OEM_WEB_CAB=GeneralR12
endif
else

ifndef OEM_WEB
OEM_WEB_CONFIG=NoOCX_$(PICSUP)
OEM_WEB_HTML=$(PICSUP)
OEM_WEB_CAB=$(PICSUP)
else
ifndef OEM_WEB_CONFIG
OEM_WEB_CONFIG=NoOCX_$(OEM_WEB)
endif
ifndef OEM_WEB_HTML
OEM_WEB_HTML=$(OEM_WEB)
endif
ifndef OEM_WEB_CAB
OEM_WEB_CAB=$(OEM_WEB)
endif
endif

endif
# Web、Strings尽量不开分支
WEB_CONFIG_PATH=$(TOP_DIR)/Web/config/$(OEM_WEB_CONFIG)
WEB_HTML_PATH=$(TOP_DIR)/Web/html/$(OEM_WEB_HTML)
WEB_CAB_PATH=$(TOP_DIR)/Web/web.cab/$(OEM_WEB_CAB)/web.cab
STRING_PATH=$(TOP_DIR)/Strings/General
PLAYER_PATH=$(TOP_DIR)/Player/NewDecoder/MediaPlayerCodec.exe

TOOL_DIR=$(TOP_DIR)/Packshop/Tool#

#SOFIA_DIST=$(WORK_DIR)/bin
TMP_DIST=$(WORK_DIR)/tempDist
SUB_NAME_FILE="upFilename"
ID_FILE="devid"
EXTID_CFG_FILE="ExtDevIDConfig.custom"
SUB_NAME=$(shell cat $(WORK_DIR)/$(SUB_NAME_FILE) | awk -F ' ' '{print $$1}')
UPGRADE_FILE_NAME=$(GUI_VENDOR)_$(OEM_VENDOR_DIR)_$(shell basename $(shell pwd))_V$(VERSION_MAJ).$(VERSION_MIN).$(VERSION_FIX)$(SUB_NAME).$(shell date +%Y%m%d).bin
BURN_FILE_NAME=upall_$(GUI_VENDOR)_$(OEM_VENDOR_DIR)_$(shell basename $(shell pwd))$(SUB_NAME).$(shell date +%Y%m%d).bin
BURN_VERIFY_NAME=upall_verify_$(shell basename $(shell pwd)).$(shell date +%Y%m%d).img

# 发布目录
ifndef RELEASE_DIR
    RELEASE_DIR=/home/share/$(LOGNAME)/Dist#
endif
BUILD_LEFT1=$(RELEASE_DIR)
BUILD_LEFT2=$(BUILD_LEFT1)/$(shell date +%Y%m%d)#
BUILD_LEFT3=$(BUILD_LEFT2)/$(GUI_VENDOR)_$(OEM_VENDOR_DIR)
BUILD_ROOT=$(BUILD_LEFT3)/$(shell basename $(shell pwd))# 发布程序的目录

# 中间文件目录，存放.o文件的位置
SOFIA_INTERMEDIATEDIR=$(OBJS_DIR)/$(shell basename $(shell pwd))_$(GUI_VENDOR)_$(OEM_VENDOR_DIR)_tmp#

# 存放生成的Sofia可执行文件的目录
SOFIA_TARGETDIR=$(OBJS_DIR)/bin#开发环境使用这个
SOFIA_DIST=$(SOFIA_TARGETDIR)
BUILD_DIR:=$(shell basename $(shell pwd))
OEM_ID:=$(shell grep -w \<$(OEM_VENDOR_DIR)\> $(TOP_DIR)/ProgramID/oem | awk -F ' ' '{print $$1}')
GUI_ID:=$(shell grep -w \<$(GUI_VENDOR)\> $(TOP_DIR)/ProgramID/gui | awk -F ' ' '{print $$1}')
BUILD_ID:=$(shell grep -w \<$(BUILD_DIR)\> $(TOP_DIR)/ProgramID/builddir | awk -F ' ' '{print $$1}')


#svn提交目录和文件定义
GUI_EXT:=_$(GUI_VENDOR)
ifeq ($(GUI_VENDOR), General)
    GUI_EXT:=
endif

ifeq ($(GUI_VENDOR), SimpGeneral)
    GUI_EXT:=
endif

ifdef EXT
    USER_EXT:=_$(EXT)
endif

ifeq ($(OEM_VENDOR_DIR), General)
    SVN_SUB:=Dev/$(OEM_VENDOR_DIR)/$(BUILD_DIR)/$(VERSION_FIX)/$(shell date +%Y-%m-%d)
    NOTE_DIR:=Dev/$(OEM_VENDOR_DIR)/$(BUILD_DIR)/$(VERSION_FIX)/ReleaseNote
    SVN_PRODUCT_TYPE:=$(BUILD_DIR)  
else
    SVN_SUB:=Dev/$(OEM_VENDOR_DIR)/$(VERSION_FIX)/$(shell date +%Y-%m-%d)/$(BUILD_DIR)$(GUI_EXT)$(USER_EXT)
    NOTE_DIR:=Dev/$(OEM_VENDOR_DIR)/$(VERSION_FIX)/ReleaseNote
    SVN_PRODUCT_TYPE:=$(BUILD_DIR)$(GUI_EXT)$(USER_EXT) 
endif

#用户私有的云台协议和串口协议目录名
ifndef OEM_SQUIRREL
	OEM_SQUIRREL := $(OEM_VENDOR)
endif

ifndef OEM_LOGO_DIR
			OEM_LOGO_DIR := $(OEM_VENDOR_DIR)
endif

#客户定制的DDNS协议
DDNS_TYPES = $(shell cat ./Custom/CustomConfig/NetWork.custom | grep DDNSKey | tr '\n' ' ' | sed 's/\t//g' | sed 's/ //g')

COMM_FILE_LIST:=$(UPGRADE_FILE_NAME);\
                $(BURN_FILE_NAME);\
                update.img;\
                $(BURN_VERIFY_NAME);\
                u-boot.bin;\
                u-boot.bin.img;\
                u-boot.env.bin.img;\
                logo-x.cramfs.img;\
                InstallDesc;\
                Sofia

MD5_FILE_LIST:=$(UPGRADE_FILE_NAME);\
				$(BURN_FILE_NAME)

makSofia:
	
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi

	@if [ -z "$(OEM_ID)" ]; then \
		echo "ERR:  not foune <$(OEM_VENDOR_DIR)>, from \"Resource/ProgramID/oem\" file."; \
		exit 1; \
	elif [ -n "`echo $(OEM_ID) | grep [a-zOIZ]`" ]; then \
		echo "ERR:  OEM_ID($(OEM_ID)) can't include 'a'-'z', 'O' , 'I' and 'Z'"; \
		exit 1; \
	fi 
	
	@if [ -z "$(GUI_ID)" ]; then \
		echo "ERR:  not foune <$(GUI_VENDOR)>, from \"Resource/ProgramID/gui\" file."; \
		exit 1; \
	elif [ -n "`echo $(GUI_ID) | grep [a-zOIZ]`" ]; then \
		echo "ERR:  GUI_ID($(GUI_ID)) can't include 'a'-'z', 'O' , 'I' and 'Z'"; \
		exit 1; \
	fi
	
	@if [ -z "$(BUILD_ID)" ]; then \
		echo "ERR:  not foune <$(BUILD_DIR)>, from \"Resource/ProgramID/builddir\" file."; \
		exit 1; \
	fi

	rm -rf $(SOFIA_INTERMEDIATEDIR)/Main.*
	rm -rf $(SOFIA_INTERMEDIATEDIR)/../bin/Sofia
	
	# 编译应用程序
	@make -C $(SOURCE_DIR)/Build/$(MAKE_DIR) \
		INTERMEDIATEDIR=$(SOFIA_INTERMEDIATEDIR) \
		TARGETDIR=$(SOFIA_TARGETDIR) \
		OEM_VENDOR=$(OEM_VENDOR) \
		GUI_VENDOR=$(GUI_VENDOR)	\
		PRODUCT_TYPE=$(PRODUCT_TYPE) \
		EXTRA_PRODUCT_TYPE=$(EXTRA_PRODUCT_TYPE) \
		EXTRA_DEF=$(EXTRA_DEF) \
		OEM_ID=$(OEM_ID) \
		GUI_ID=$(GUI_ID) \
		BUILD_ID=$(BUILD_ID) \
		DDNS_TYPES=$(DDNS_TYPES)
	@if [ ! -z $(LIBAPPCOMMITPATH) ];then \
		cp -f $(SOFIA_INTERMEDIATEDIR)/libapp.a $(LIBAPPCOMMITPATH)/$(MAKE_DIR); \
	fi		
	@echo "$(SOFIA_TARGETDIR)/Sofia"

buildDir:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	
	@echo "创建主工作目录:$(WORK_DIR)"
	@if [ ! -d $(WORK_DIR) ]; \
		then mkdir $(WORK_DIR); \
	fi
	
	@echo "创建WEB工作目录:$(WORK_DIR)/Web"
	@if [ ! -d $(WORK_DIR)/Web ]; \
		then mkdir $(WORK_DIR)/Web; \
	else \
		rm -fr  $(WORK_DIR)/Web/*; \
	fi
	
	@echo "创建Custom工作目录:$(WORK_DIR)/Custom"
	@if [ ! -d $(WORK_DIR)/Custom ]; \
		then mkdir $(WORK_DIR)/Custom; \
	else \
		rm -fr  $(WORK_DIR)/Custom/*; \
	fi
	
	@echo "创建Mtd工作目录:$(WORK_DIR)/Mtd"
	@if [ ! -d $(WORK_DIR)/Mtd ]; \
		then mkdir $(WORK_DIR)/Mtd; \
	else \
		rm -fr  $(WORK_DIR)/Mtd/*; \
	fi
	
	@echo "创建Logo工作目录$(WORK_DIR)/Logo"
	@if [ ! -d $(WORK_DIR)/Logo ]; \
		then mkdir $(WORK_DIR)/Logo; \
	else \
		rm -fr  $(WORK_DIR)/Logo/*; \
	fi
	
	@echo "创建user工作目录:$(WORK_DIR)/usr"
	@if [ ! -d $(WORK_DIR)/usr ]; \
		then mkdir $(WORK_DIR)/usr; \
	else \
		rm -fr  $(WORK_DIR)/usr/*; \
	fi
	
	@echo "创建romfs工作目录:$(WORK_DIR)/romfs"
	@if [ ! -d $(WORK_DIR)/romfs ]; \
		then mkdir $(WORK_DIR)/romfs; \
	else \
		rm -fr  $(WORK_DIR)/romfs/*; \
	fi
	@echo "创建从ARM9 romfs工作目录:$(WORK_DIR)/Arm9romfs"
	@if [ ! -d $(WORK_DIR)/Arm9romfs ]; \
		then mkdir $(WORK_DIR)/Arm9romfs; \
	else \
		rm -fr  $(WORK_DIR)/Arm9romfs/*; \
	fi
	@echo "创建Custom工作目录:$(WORK_DIR)/Web"
	@if [ ! -d $(WORK_DIR)/Custom ]; \
		then mkdir $(WORK_DIR)/Web; \
	else \
		rm -fr  $(WORK_DIR)/Web/*; \
	fi
	
	
	@echo "创建slvfs工作目录:$(WORK_DIR)/slvfs"
	@if [ ! -d $(WORK_DIR)/slvfs ]; \
		then mkdir $(WORK_DIR)/slvfs; \
	else \
		rm -fr  $(WORK_DIR)/slvfs/*; \
	fi
	
	@echo "创建slvromfs工作目录:$(WORK_DIR)/slvromfs"
	@if [ ! -d $(WORK_DIR)/slvromfs ]; \
		then mkdir $(WORK_DIR)/slvromfs; \
	else \
		rm -fr  $(WORK_DIR)/slvromfs/*; \
	fi
	
	@echo "内核目录:$(WORK_DIR)/kernel"
	@if [ ! -d $(WORK_DIR)/kernel ]; \
		then mkdir $(WORK_DIR)/kernel; \
	else \
		rm -fr  $(WORK_DIR)/kernel/*; \
	fi

	@echo "临时发布目录:$(TMP_DIST)"
	@if [ ! -d $(TMP_DIST) ]; \
		then mkdir $(TMP_DIST); \
	else \
		rm -fr  $(TMP_DIST)/*; fi
		
	@echo "从片Build目录"
	@mkdir $(TMP_DIST)/Slave
	
	@echo "产品发布目录: $(BUILD_ROOT)"
	@mkdir -p $(BUILD_LEFT1)
	@mkdir -p $(BUILD_LEFT2)
	@mkdir -p $(BUILD_LEFT3)
	
	@if [ ! -d $(BUILD_ROOT) ]; \
		then mkdir $(BUILD_ROOT); \
	else \
		rm -fr $(BUILD_ROOT)/*; \
	fi
	
preBuild: makSofia buildDir
	@$(TOOL_DIR)/packCleaner -day 5 $(BUILD_LEFT1)
	
postBuild:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	
	@cp -rf $(TMP_DIST)/u-boot.bin $(BUILD_ROOT)/
	@cp -fr $(TMP_DIST)/web-x.cramfs $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/custom-x.cramfs $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/logo-x.cramfs $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/user-x.cramfs $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/romfs-x.cramfs $(BUILD_ROOT)
	
	@cp -fr $(TMP_DIST)/u-boot.bin.img $(BUILD_ROOT)
	#@cp -fr $(TMP_DIST)/u-boot-all.bin.img $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/u-boot.env.bin.img $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/web-x.cramfs.img $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/custom-x.cramfs.img $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/logo-x.cramfs.img $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/user-x.cramfs.img $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/romfs-x.cramfs.img $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/mtd-x.jffs2.img $(BUILD_ROOT)
	@cp -fr $(shell pwd)/InstallDesc $(BUILD_ROOT)
	@cp -fr $(TMP_DIST)/u-boot.env.bin $(BUILD_ROOT)
	@cp -fr /home/share/$(USER)/General/Sofia $(BUILD_ROOT)

	@sed -i -e '/Hardware/a    \   "DevID\" : \"'"$(shell cat ${WORK_DIR}/$(ID_FILE))"'\"\,' $(BUILD_ROOT)/InstallDesc;
	@$(TOOL_DIR)/addCRC $(BUILD_ROOT) $(TOOL_DIR)/jq $(UPGRADE_FILE_NAME)

ifdef NETWORK_UPGRADE_UBOOT
	@$(TOOL_DIR)/zip -j $(BUILD_ROOT)/$(UPGRADE_FILE_NAME) \
				$(BUILD_ROOT)/web-x.cramfs.img	\
				$(BUILD_ROOT)/custom-x.cramfs.img 	\
				$(BUILD_ROOT)/user-x.cramfs.img	\
				$(BUILD_ROOT)/romfs-x.cramfs.img	\
				$(BUILD_ROOT)/logo-x.cramfs.img	\
				$(BUILD_ROOT)/u-boot.bin.img	\
				$(BUILD_ROOT)/u-boot.env.bin.img	\
				$(BUILD_ROOT)/InstallDesc
else
	@$(TOOL_DIR)/zip -j $(BUILD_ROOT)/$(UPGRADE_FILE_NAME) \
				$(BUILD_ROOT)/web-x.cramfs.img	\
				$(BUILD_ROOT)/custom-x.cramfs.img 	\
				$(BUILD_ROOT)/user-x.cramfs.img	\
				$(BUILD_ROOT)/romfs-x.cramfs.img	\
				$(BUILD_ROOT)/logo-x.cramfs.img	\
				$(BUILD_ROOT)/InstallDesc
endif
	#@$(TOOL_DIR)/chhead2xm $(BUILD_ROOT)/$(UPGRADE_FILE_NAME)	
					
	@$(TOOL_DIR)/mkpkt.hi3520 $(BUILD_ROOT)/update.img \
				$(BUILD_ROOT)/custom-x.cramfs.img 	\
				$(BUILD_ROOT)/romfs-x.cramfs.img \
				$(BUILD_ROOT)/user-x.cramfs.img	\
				$(BUILD_ROOT)/logo-x.cramfs.img		\
				$(BUILD_ROOT)/web-x.cramfs.img

	$(TOOL_DIR)/mkall_16M $(BUILD_ROOT)/$(BURN_FILE_NAME)	\
				$(BUILD_ROOT)/u-boot.bin	0 	50000	\
				$(BUILD_ROOT)/u-boot.env.bin	50000 	60000	\
				$(BUILD_ROOT)/romfs-x.cramfs	60000 	440000 \
				$(BUILD_ROOT)/user-x.cramfs	440000  b20000 \
				$(BUILD_ROOT)/web-x.cramfs 	b20000  ca0000 \
				$(BUILD_ROOT)/custom-x.cramfs  ca0000 f60000 \
				$(BUILD_ROOT)/logo-x.cramfs	f60000 f80000

	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T kernel -C gzip -a 0x0 -e 0x1000000 -n linux -d \
		$(BUILD_ROOT)/$(BURN_FILE_NAME) $(BUILD_ROOT)/$(BURN_VERIFY_NAME)
		
	@echo ""
	@echo "Distrubute files following:"
	@echo "$(BUILD_ROOT)/$(UPGRADE_FILE_NAME)"
	@echo "$(BUILD_ROOT)/update.img"
	@echo "$(BUILD_ROOT)/web-x.cramfs.img"
	@echo "$(BUILD_ROOT)/custom-x.cramfs.img"
	@echo "$(BUILD_ROOT)/logo-x.cramfs.img"
	@echo "$(BUILD_ROOT)/u-boot.bin.img"
	@echo "$(BUILD_ROOT)/user-x.cramfs.img"
	@echo "$(BUILD_ROOT)/romfs-x.cramfs.img"
	@echo "$(BUILD_ROOT)/$(BURN_FILE_NAME)"
	@echo "$(BUILD_ROOT)/Sofia"
					
# 制作web升级包
wimg:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	
	@echo ""
	@echo "Start to make web-x.cramfs ..."
	@rm -fr $(WORK_DIR)/Web/*
	#web一般都不太做特殊，暂时如此
	#注意必须先拷贝html，拷贝web.cab, 再拷贝config
	@echo "拷贝WEB html"
	@if [ -d $(WEB_HTML_PATH) ];  then\
		$(TOOL_DIR)/cpscript cpd $(WEB_HTML_PATH) $(WORK_DIR)/Web; \
	else \
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Web/html/General $(WORK_DIR)/Web; \
	fi
ifndef USE_WEB_NOOCX	
	@echo "拷贝WEB web.cab"
	@if [ -e $(WEB_CAB_PATH) ];  then\
		cp $(WEB_CAB_PATH) $(WORK_DIR)/Web -f; \
	else \
		cp $(TOP_DIR)/Web/web.cab/General/web.cab $(WORK_DIR)/Web -f; \
	fi
	echo $(USE_WEB_NOOCX)
	echo $(WEB_CAB_PATH)
endif	
	@echo "拷贝WEB config"
	@if [ -d $(WEB_CONFIG_PATH) ];  then\
		$(TOOL_DIR)/cpscript cpd $(WEB_CONFIG_PATH) $(WORK_DIR)/Web; \
	else \
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Web/config/General $(WORK_DIR)/Web; \
	fi
	
	@echo "WEB LOGO 文件"
	@if [ -e $(shell pwd)/Pics/logo.gif ]; then 	\
		cp $(shell pwd)/Pics/logo.gif $(WORK_DIR)/Web; 	\
	else \
		echo "No Custom logo Pics!"; \
	fi
	
	@echo "WEB 右上角LOGO2 文件"
	@if [ -e $(shell pwd)/Pics/logo2.gif ]; then 	\
		cp $(shell pwd)/Pics/logo2.gif $(WORK_DIR)/Web; 	\
	else \
		echo "No Custom logo2 Pics!"; \
	fi

	@echo "WEB 登陆上方logo 文件"
	@if [ -e $(shell pwd)/Pics/l_topLogo.gif ]; then 	\
		cp $(shell pwd)/Pics/l_topLogo.gif $(WORK_DIR)/Web; 	\
	else \
		echo "No Custom l_topLogo.gif Pics!"; \
	fi
		
	@echo "WEB 登陆logo背景 文件"
	@if [ -e $(shell pwd)/Pics/l_bgm.gif ]; then 	\
		cp $(shell pwd)/Pics/l_bgm.gif $(WORK_DIR)/Web; 	\
	else \
		echo "No Custom l_bgm.gif Pics!"; \
	fi
	
	@echo "WEB 登陆logo背景 文件"
	@if [ -e $(shell pwd)/Pics/l_logo.gif ]; then 	\
		cp $(shell pwd)/Pics/l_logo.gif $(WORK_DIR)/Web; 	\
	else \
		echo "No Custom l_logo.gif Pics!"; \
	fi
	@echo "web.cab 文件"
	@if [ -e $(shell pwd)/Pics/web.cab ]; then 	\
		cp $(shell pwd)/Pics/web.cab $(WORK_DIR)/Web; 	\
	else \
		echo "No Custom web.cab Pics!"; \
	fi
	@echo "WEB 登陆按钮图片"
	@if [ -e $(shell pwd)/Pics/bt.gif ]; then 	\
		cp $(shell pwd)/Pics/bt.gif $(WORK_DIR)/Web; 	\
	else \
		echo "No Custom bt.gif Pics!"; \
	fi
	
	@echo "WEB 登路界面位置配置"
	@if [ -e $(shell pwd)/Pics/config.js ]; then 	\
		cp $(shell pwd)/Pics/config.js $(WORK_DIR)/Web; 	\
	else \
		echo "No Custom config.js Pics!"; \
	fi
	
	#@$(TOOL_DIR)/mkcramfs $(WORK_DIR)/Web $(TMP_DIST)/web-x.cramfs
	@rm $(TMP_DIST)/web-x.cramfs -f
	@$(TOOL_DIR)/mksquashfs $(WORK_DIR)/Web $(TMP_DIST)/web-x.cramfs -b 64K -comp xz

	@if [ $$? -ne 0 ]; then                              \
		echo "make web-x.cramfs fail!";					\
		exit 1;                                         \
	fi;

	@echo ""
	@echo "Start to make web-x.cramfs.img ..."
	@$(TOOL_DIR)/mkimage.chklen  -A arm -O linux -T standalone -C gzip -a 0xb20000 \
	-e 0xca0000 -n linux -d $(TMP_DIST)/web-x.cramfs $(TMP_DIST)/web-x.cramfs.img

	@if [ $$? -ne 0 ]; then					\
		echo "make web-x.cramfs.img fail.";	\
		exit 1;								\
	fi
	
	@echo "$(TMP_DIST)/web-x.cramfs.img done"
	
# 制作custom升级包，该升级包由默认配置文件，字符串，产品定义文件组成
cimg:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi

	@rm -fr $(WORK_DIR)/Custom/*
	
	$(TOOL_DIR)/cpscript cpd $(shell pwd)/Custom $(WORK_DIR)/Custom; \

	@echo "拷贝图片"
	@mkdir $(WORK_DIR)/Custom/data
	@mkdir $(WORK_DIR)/Custom/data/Pics
	@mkdir $(WORK_DIR)/Custom/data/Pics/General
	
	@if [ -d $(TOP_DIR)/Picture/$(PICSUPUP) ]; \
		then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Picture/$(PICSUPUP)/General $(WORK_DIR)/Custom/data/Pics/General; \
	else \
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Picture/$(PICSUP)/General $(WORK_DIR)/Custom/data/Pics/General; \
	fi

ifneq ($(VERSION_FIX), R10)
ifneq ($(VERSION_FIX), R09)
ifneq ($(VERSION_FIX), R07)
ifndef PICTURE_OLD_PLAY
	@rm -fr $(WORK_DIR)/Custom/data/Pics/General/PlayBack/*
	@if [ -d $(TOP_DIR)/Picture/$(PICSUPUP) ]; \
		then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Picture/$(PICSUPUP)/PlayBack $(WORK_DIR)/Custom/data/Pics/General/PlayBack; \
	else \
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Picture/$(PICSUP)/PlayBack $(WORK_DIR)/Custom/data/Pics/General/PlayBack; \
	fi
endif
endif
endif
endif

ifdef PICTURE_NVR_SPLIT
	@mkdir $(WORK_DIR)/Custom/data/Pics/General/NVRSplit
	@if [ -d $(TOP_DIR)/Picture/$(PICSUPUP) ]; \
		then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Picture/$(PICSUPUP)/NVRSplit $(WORK_DIR)/Custom/data/Pics/General/NVRSplit; \
	else \
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Picture/$(PICSUP)/NVRSplit $(WORK_DIR)/Custom/data/Pics/General/NVRSplit; \
	fi
endif

	@echo "拷贝用户自定义视频丢失logo"
	@if [ -e $(shell pwd)/Pics/VideoChannelLoss.gif ]; then 	\
		cp $(shell pwd)/Pics/VideoChannelLoss.gif $(WORK_DIR)/Custom/data/Pics/General/OneClick;	\
	else \
		echo "No Custom Pics，VideoChannelLoss.gif!"; \
	fi
	
	@echo "拷贝用户自定义锁屏logo"
	@if [ -e $(shell pwd)/Pics/VideoChannelLock.gif ]; then 	\
		cp $(shell pwd)/Pics/VideoChannelLock.gif $(WORK_DIR)/Custom/data/Pics/General/OneClick;	\
	else \
		echo "No Custom Pics，VideoChannelLock.gif!"; \
	fi
	
	@echo "拷贝用户自定义9通道模式下第9通道logo"
	@if [ -e $(shell pwd)/Pics/VideoChannelBlank.gif ]; then 	\
		cp $(shell pwd)/Pics/VideoChannelBlank.gif $(WORK_DIR)/Custom/data/Pics/General/OneClick;	\
	else \
		echo "No Custom Pics，VideoChannelBlank.gif!"; \
	fi
	
	@echo "拷贝用户自定义主题配置文件"
	@if [ -d $(shell pwd)/Theme ]; then 	\
		$(TOOL_DIR)/cpscript cpd $(shell pwd)/Theme/ $(WORK_DIR)/Custom/data/Pics/General;	\
	else \
		echo "No Custom Theme!"; \
	fi
	
	@echo "拷贝字库，字体Bin和中文输入法"
	@mkdir $(WORK_DIR)/Custom/data/Fonts
	$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Common/BigFont32x32 $(WORK_DIR)/Custom/data/Fonts

ifdef SPECIAL_FONT
	@if [ -d $(TOP_DIR)/Common/$(SPECIAL_FONT)/BigFont32x32 ]; \
		then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Common/$(SPECIAL_FONT)/BigFont32x32 $(WORK_DIR)/Custom/data/Fonts; \
	else \
		echo "No SPECIAL_FONT Font!"; \
	fi
endif

	@echo "删除ftd文件"
	@if [ -f $(WORK_DIR)/Custom/data/Fonts/Font.fdt ]; then \
		rm -r $(WORK_DIR)/Custom/data/Fonts/*.fdt; \
	fi

	@echo "拷贝字符串"
	@mkdir $(WORK_DIR)/Custom/data/Strings

ifndef SUPPORT_LANGUAGE

ifdef SPECIAL_FONT
	@if [ -d $(TOP_DIR)/Common/$(SPECIAL_FONT)/Strings ]; \
		then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Common/$(SPECIAL_FONT)/Strings  $(WORK_DIR)/Custom/data/Strings; \
	else \
		echo "No SPECIAL_FONT string!"; \
	fi
endif

	@$(TOOL_DIR)/cpscript cpd $(STRING_PATH) $(WORK_DIR)/Custom/data/Strings
	@if [ $(GUI_STRING_PATH) = "General" -a -d $(TOP_DIR)/Strings/$(OEM_STRING_PATH) -a $(OEM_STRING_PATH) != "General" -o ! -d $(TOP_DIR)/Strings/$(GUI_STRING_PATH) -a -d $(TOP_DIR)/Strings/$(OEM_STRING_PATH) -a $(OEM_STRING_PATH) != "General" ];	\
		then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Strings/$(OEM_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;	\
		$(TOOL_DIR)/mergeStringFile $(STRING_PATH) $(TOP_DIR)/Strings/$(OEM_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;	\
		echo "GUI目录与General目录相同，OEM目录存在并且与General目录不同";	\
		echo "或者GUI目录不存在，OEM目录存在并且与General目录不同"; \
	elif [ -d $(TOP_DIR)/Strings/$(GUI_STRING_PATH) -a $(GUI_STRING_PATH) != "General" -a $(OEM_STRING_PATH) = "General" -o -d $(TOP_DIR)/Strings/$(GUI_STRING_PATH) -a $(GUI_STRING_PATH) != "General" -a ! -d $(TOP_DIR)/Strings/$(OEM_STRING_PATH) -o -d $(TOP_DIR)/Strings/$(GUI_STRING_PATH) -a $(GUI_STRING_PATH) != "General" -a -d $(TOP_DIR)/Strings/$(OEM_STRING_PATH) -a $(OEM_STRING_PATH) = $(GUI_STRING_PATH) ]; \
		then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Strings/$(GUI_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;	\
		$(TOOL_DIR)/mergeStringFile $(STRING_PATH) $(TOP_DIR)/Strings/$(GUI_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;	\
		echo "GUI目录存在，GUI目录与General目录不同，并且OEM目录和General目录相同";	\
		echo "或者GUI目录存在，GUI目录与General目录不同，并且OEM目录不存在"; \
		echo "或者GUI目录存在，GUI目录与General目录不同，并且OEM目录和GUI目录相同"; \
	elif [ -d $(TOP_DIR)/Strings/$(GUI_STRING_PATH) -a $(GUI_STRING_PATH) != "General" -a -d $(TOP_DIR)/Strings/$(OEM_STRING_PATH) -a $(OEM_STRING_PATH) != "General" -a $(OEM_STRING_PATH) != $(GUI_STRING_PATH) ]; \
		then mkdir $(WORK_DIR)/tempdir;	\
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Strings/$(GUI_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;	\
		$(TOOL_DIR)/mergeStringFile $(STRING_PATH) $(TOP_DIR)/Strings/$(GUI_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;	\
		$(TOOL_DIR)/cpscript cpd $(WORK_DIR)/Custom/data/Strings $(WORK_DIR)/tempdir;	\
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Strings/$(OEM_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;	\
		$(TOOL_DIR)/mergeStringFile $(WORK_DIR)/tempdir $(TOP_DIR)/Strings/$(OEM_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;rm -rf $(WORK_DIR)/tempdir;	\
		echo "GUI目录存在，OEM目录存在，且三者都不相同";	\
	else 	\
		echo "using General Language";	\
	fi

ifdef SPECIAL_FONT	
	@echo "用户特殊要求的语言"
	@mkdir $(WORK_DIR)/tempdir;	\
	$(TOOL_DIR)/cpscript cpd $(WORK_DIR)/Custom/data/Strings $(WORK_DIR)/tempdir;	\
	$(TOOL_DIR)/mergeStringFile $(TOP_DIR)/Common/Strings $(WORK_DIR)/tempdir $(WORK_DIR)/Custom/data/Strings;	\
	rm -fr $(WORK_DIR)/tempdir;
endif

else

ifdef SPECIAL_FONT
	@if [ -d $(TOP_DIR)/Common/$(SPECIAL_FONT)/Strings ]; \
		then $(TOOL_DIR)/cpLanguage $(TOP_DIR)/Common/$(SPECIAL_FONT)/Strings $(WORK_DIR)/Custom/data/Strings $(SUPPORT_LANGUAGE); \
	else \
		echo "No SPECIAL_FONT string!"; \
	fi
endif

	@$(TOOL_DIR)/cpLanguage $(STRING_PATH) $(WORK_DIR)/Custom/data/Strings $(SUPPORT_LANGUAGE)
	@if [ $(GUI_STRING_PATH) = "General" -a -d $(TOP_DIR)/Strings/$(OEM_STRING_PATH) -a $(OEM_STRING_PATH) != "General" -o ! -d $(TOP_DIR)/Strings/$(GUI_STRING_PATH) -a -d $(TOP_DIR)/Strings/$(OEM_STRING_PATH) -a $(OEM_STRING_PATH) != "General" ];	\
		then $(TOOL_DIR)/cpLanguage $(TOP_DIR)/Strings/$(OEM_STRING_PATH) $(WORK_DIR)/Custom/data/Strings $(SUPPORT_LANGUAGE);	\
		$(TOOL_DIR)/mergeStringFile $(STRING_PATH) $(TOP_DIR)/Strings/$(OEM_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;	\
		echo "GUI目录与General目录相同，OEM目录存在并且与General目录不同";	\
		echo "或者GUI目录不存在，OEM目录存在并且与General目录不同"; \
	elif [ -d $(TOP_DIR)/Strings/$(GUI_STRING_PATH) -a $(GUI_STRING_PATH) != "General" -a $(OEM_STRING_PATH) = "General" -o -d $(TOP_DIR)/Strings/$(GUI_STRING_PATH) -a $(GUI_STRING_PATH) != "General" -a ! -d $(TOP_DIR)/Strings/$(OEM_STRING_PATH) -o -d $(TOP_DIR)/Strings/$(GUI_STRING_PATH) -a $(GUI_STRING_PATH) != "General" -a -d $(TOP_DIR)/Strings/$(OEM_STRING_PATH) -a $(OEM_STRING_PATH) = $(GUI_STRING_PATH) ]; \
		then $(TOOL_DIR)/cpLanguage $(TOP_DIR)/Strings/$(GUI_STRING_PATH) $(WORK_DIR)/Custom/data/Strings $(SUPPORT_LANGUAGE);	\
		$(TOOL_DIR)/mergeStringFile $(STRING_PATH) $(TOP_DIR)/Strings/$(GUI_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;	\
		echo "GUI目录存在，GUI目录与General目录不同，并且OEM目录和General目录相同";	\
		echo "或者GUI目录存在，GUI目录与General目录不同，并且OEM目录不存在"; \
		echo "或者GUI目录存在，GUI目录与General目录不同，并且OEM目录和GUI目录相同"; \
	elif [ -d $(TOP_DIR)/Strings/$(GUI_STRING_PATH) -a $(GUI_STRING_PATH) != "General" -a -d $(TOP_DIR)/Strings/$(OEM_STRING_PATH) -a $(OEM_STRING_PATH) != "General" -a $(OEM_STRING_PATH) != $(GUI_STRING_PATH) ]; \
		then mkdir $(WORK_DIR)/tempdir;	\
		$(TOOL_DIR)/cpLanguage $(TOP_DIR)/Strings/$(GUI_STRING_PATH) $(WORK_DIR)/Custom/data/Strings $(SUPPORT_LANGUAGE);	\
		$(TOOL_DIR)/mergeStringFile $(STRING_PATH) $(TOP_DIR)/Strings/$(GUI_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;	\
		$(TOOL_DIR)/cpscript cpd $(WORK_DIR)/Custom/data/Strings $(WORK_DIR)/tempdir;	\
		$(TOOL_DIR)/cpLanguage $(TOP_DIR)/Strings/$(OEM_STRING_PATH) $(WORK_DIR)/Custom/data/Strings $(SUPPORT_LANGUAGE);	\
		$(TOOL_DIR)/mergeStringFile $(WORK_DIR)/tempdir $(TOP_DIR)/Strings/$(OEM_STRING_PATH) $(WORK_DIR)/Custom/data/Strings;rm -rf $(WORK_DIR)/tempdir;	\
		echo "GUI目录存在，OEM目录存在，且三者都不相同";	\
	else 	\
		echo "using General Language";	\
	fi

ifdef SPECIAL_FONT	
	@echo "用户特殊要求的语言"
	@mkdir $(WORK_DIR)/tempdir;	\
	$(TOOL_DIR)/cpscript cpd $(WORK_DIR)/Custom/data/Strings $(WORK_DIR)/tempdir;	\
	$(TOOL_DIR)/mergeStringFile $(TOP_DIR)/Common/Strings $(WORK_DIR)/tempdir $(WORK_DIR)/Custom/data/Strings;	\
	rm -fr $(WORK_DIR)/tempdir;
endif

endif

	@echo "拷贝播放器"
	@mkdir $(WORK_DIR)/Custom/Player/
	@if [ -f $(PLAYER_PATH) ]; \
		then cp -rf $(PLAYER_PATH) $(WORK_DIR)/Custom/Player/ ;\
	else \
		echo "No Player!"; \
	fi

	@cp $(WORK_DIR)/$(EXTID_CFG_FILE) $(WORK_DIR)/Custom/CustomConfig/$(EXTID_CFG_FILE)
	@sed -i -e '/LogoArea/a    \   "LogoPartType\" : \"'"cramfs"'\"\,' $(WORK_DIR)/Custom/ProductDefinition;
	@echo "Start to make custom-x.cramfs ..."
#	@$(TOOL_DIR)/mkcramfs $(WORK_DIR)/Custom $(TMP_DIST)/custom-x.cramfs
	@rm $(TMP_DIST)/custom-x.cramfs -f
	@$(TOOL_DIR)/mksquashfs $(WORK_DIR)/Custom $(TMP_DIST)/custom-x.cramfs -b 256K -comp xz
	
	@if [ $$? -ne 0 ]; then								\
		echo "make $(TMP_DIST)/custom-x.cramfs fail!";	\
		exit 1;											\
	fi
	@echo ""
	@echo "Start to make custom-x.cramfs.img ..."
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T standalone -C gzip -a 0xca0000 \
		-e 0xf60000 -n linux -d $(TMP_DIST)/custom-x.cramfs $(TMP_DIST)/custom-x.cramfs.img
	@if [ $$? -ne 0 ]; then									\
		echo "make $(TMP_DIST)/custom-x.cramfs.img fail."	\
		exit 1;												\
	fi
	
	@echo "$(TMP_DIST)/custom-x.cramfs.img done"

# 制作mtd级包，Config & Log
dimg:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	
#用mtd 配置
ifdef _MTD_CONFIG_
	@rm -fr $(WORK_DIR)/Mtd/*
	@tar -zxvf $(TOP_DIR)/Packshop/HI3520DV300/mtd.tgz -C $(WORK_DIR)/Mtd

	@echo "Start to make mtd-x.jffs2 ..."
	@$(TOOL_DIR)/mkfs.jffs2 -d $(WORK_DIR)/Mtd -l -e 0x20000 -o $(TMP_DIST)/mtd-x.jffs2
	@if [ $$? -ne 0 ]; then								\
		echo "make $(TMP_DIST)/mtd-x.jffs2 fail!";	\
		exit 1;											\
	fi
else
	@rm -fr $(WORK_DIR)/Mtd/*
	
	@echo "Start to make ALL oxFF mtd-x.jffs2 ..."
	@$(TOOL_DIR)/mkBuffNull $(TMP_DIST)/mtd-x.jffs2 0xf80000  0x1000000
	@if [ $$? -ne 0 ]; then								\
		echo "make $(TMP_DIST)/mtd-x.jffs2 fail!";	\
		exit 1;											\
	fi
endif

	@echo ""
	@echo "Start to make mtd-x.jffs2.img ..."
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T standalone -C gzip -a 0xf80000 \
		-e 0x1000000 -n linux -d $(TMP_DIST)/mtd-x.jffs2 $(TMP_DIST)/mtd-x.jffs2.img
	@if [ $$? -ne 0 ]; then									\
		echo "make $(TMP_DIST)/mtd-x.jffs2.img fail."	\
		exit 1;												\
	fi
	chmod 777 $(TMP_DIST)/mtd-x.jffs2*
	@echo "$(TMP_DIST)/mtd-x.jffs2.img done"	

# 制作logo升级包
limg:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	
	@echo "拷贝图片到Logo目录"
	@rm -fr $(WORK_DIR)/Logo/*

	@if [ -d $(TOP_DIR)/Logo/$(OEM_LOGO_DIR) ] && [ $(OEM_VENDOR_DIR) != "General" ]; \
			then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Logo/$(OEM_LOGO_DIR) $(WORK_DIR)/Logo;	\
	elif [ -d $(TOP_DIR)/Logo/$(OEM_VENDOR_DIR) ] && [ $(OEM_VENDOR_DIR) != "General" ]; \
			then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Logo/$(OEM_VENDOR_DIR) $(WORK_DIR)/Logo;	\
	elif [ -d $(TOP_DIR)/Logo/$(PICSUP) ] && [ $(PICSUP) != "General" ]; \
			then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Logo/$(PICSUP) $(WORK_DIR)/Logo;	\
	elif 	[ -d $(TOP_DIR)/Logo/$(PICSUPUP) ] && [ $(PICSUPUP) != "General" ]; \
			then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Logo/$(PICSUPUP) $(WORK_DIR)/Logo;	\
	elif 	[ -d $(TOP_DIR)/Logo/$(OEM_VENDOR) ] && [ $(OEM_VENDOR) != "General" ]; \
			then $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Logo/$(OEM_VENDOR) $(WORK_DIR)/Logo;	\
	else	\
		  $(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Logo/GeneralV6000 $(WORK_DIR)/Logo;	\
	fi

	@if [ -d $(shell pwd)/Logo ]; then 	\
		rm -fr $(WORK_DIR)/Logo/*;		\
		$(TOOL_DIR)/cpscript cpd $(shell pwd)/Logo $(WORK_DIR)/Logo;	\
	fi
	
	@if [ -e $(shell pwd)/Pics/logo_close.gif ]; then 	\
		if [ ! -d $(WORK_DIR)/Logo/Colse ]; then mkdir $(WORK_DIR)/Logo/Colse; fi; \
		cp $(shell pwd)/Pics/logo_close.gif $(WORK_DIR)/Logo/Colse;	\
	fi
	
	@if [ -e $(shell pwd)/Pics/uboot_logo.jpg ]; then 	\
		if [ ! -d $(WORK_DIR)/Logo/UbootLogo ]; then mkdir $(WORK_DIR)/Logo/UbootLogo; fi; \
		cp $(shell pwd)/Pics/uboot_logo.jpg $(WORK_DIR)/Logo/UbootLogo;	\
	fi
	
	@echo "Start to make logo-x.cramfs ..."
	@$(TOOL_DIR)/mkcramfs $(WORK_DIR)/Logo $(TMP_DIST)/logo-x.cramfs
	@if [ $$? -ne 0 ]; then								\
		echo "make $(TMP_DIST)/log-x.cramfs fail!";		\
		exit 1;											\
	fi
	
	@echo ""
	@echo "Start to make logo-x.cramfs.img ..."
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T standalone -C gzip -a 0xf60000 \
	-e 0xf80000 -n linux -d $(TMP_DIST)/logo-x.cramfs $(TMP_DIST)/logo-x.cramfs.img
	@if [ $$? -ne 0 ]; then								\
		echo "make logo-x.cramfs.img fail.";			\
		exit 1;											\
	fi

	@echo "$(TMP_DIST)/logo-x.cramfs.img done"

# 制作armboot升级包
aimg:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	
	@echo ""
	@echo "Start to make u-boot.bin.img ..."
	#uboot最后2k做为设备信息，不能被覆盖
	@cp $(TOP_DIR)/Packshop/HI3520DV300/uboot/u-boot.bin $(TMP_DIST)/u-boot.bin
	
	@if [ -e $(SOURCE_DIR)/Build/$(MAKE_DIR)/uboot/u-boot.bin ]; then 	\
		cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/uboot/u-boot.bin $(TMP_DIST)/u-boot.bin;	\
	fi
	
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T firmware -C gzip -a 0x0 \
	-e 0x50000 -n linux -d $(TMP_DIST)/u-boot.bin $(TMP_DIST)/u-boot.bin.img
	@if [ $$? -ne 0 ]; then								\
		echo "make u-boot.bin.img fail.";					\
		exit 1;											\
	fi
	
	@echo "$(TMP_DIST)/u-boot.bin.img done"	
	
# 制作包括环境变量的armboot升级包	
u-allimg:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	@echo ""
	@echo "Start to make u-boot-all.bin.img ..."

	@cp $(TOP_DIR)/Packshop/HI3520DV300/uboot/u-boot.bin $(TMP_DIST)/u-boot.bin
	@cp $(TOP_DIR)/Packshop/HI3520DV300/uboot/u-boot.env.bin $(TMP_DIST)/u-boot.env.bin
	
	@if [ -e $(SOURCE_DIR)/Build/$(MAKE_DIR)/uboot/u-boot.bin ]; then 	\
		cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/uboot/u-boot.bin $(TMP_DIST)/u-boot.bin;	\
	fi
	@if [ -e $(SOURCE_DIR)/Build/$(MAKE_DIR)/uboot/u-boot.env.bin ]; then 	\
		cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/uboot/u-boot.env.bin $(TMP_DIST)/u-boot.env.bin;	\
	fi
	
	@$(TOOL_DIR)/mergeuboot $(TMP_DIST)/u-boot-all.bin 0x60000	\
	$(TMP_DIST)/u-boot.bin 0 0x50000	\
	$(TMP_DIST)/u-boot.env.bin 0x50000 0x60000
	
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T firmware -C gzip -a 0x0 \
	-e 0x60000 -n linux -d $(TMP_DIST)/u-boot-all.bin $(TMP_DIST)/u-boot-all.bin.img
	@if [ $$? -ne 0 ]; then								\
		echo "make u-boot-all.bin.img fail.";					\
		exit 1;											\
	fi
	
	@echo "$(TMP_DIST)/u-boot-all.bin.img done"	

# 制作u-boot.env.bin的uboot环境变量升级包
u-envimg:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	@echo ""
	@echo "Start to make u-boot.env.bin.img ..."

	@cp $(TOP_DIR)/Packshop/HI3520DV300/uboot/u-boot.env.bin $(TMP_DIST)/u-boot.env.bin

	@if [ -e $(SOURCE_DIR)/Build/$(MAKE_DIR)/uboot/u-boot.env.bin ]; then 	\
		cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/uboot/u-boot.env.bin $(TMP_DIST)/u-boot.env.bin;	\
	fi
	
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T firmware -C gzip -a 0x50000 \
	-e 0x60000 -n linux -d $(TMP_DIST)/u-boot.env.bin $(TMP_DIST)/u-boot.env.bin.img
	@if [ $$? -ne 0 ]; then								\
		echo "make u-boot.env.bin.img fail.";					\
		exit 1;											\
	fi

	@echo "$(TMP_DIST)/u-boot.env.bin.img done"	

# 制作romfs升级包
rimg:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	
	@rm -fr $(WORK_DIR)/romfs/*
	@sudo tar -zxvf $(TOP_DIR)/Packshop/HI3520DV300/romfs$(TELNET_PWD).tgz -C $(WORK_DIR)/romfs

	@echo "拷贝rcS脚本"	
	@if [ -d $(SOURCE_DIR)/Build/$(MAKE_DIR)/etc ]; then \
		cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/etc/rcS  $(WORK_DIR)/romfs/etc/init.d ; \
	fi
	
	@echo "拷贝dvrbox脚本"
	@if [ -e $(TOP_DIR)/Packshop/HI3520DV300/bin/dvrbox ]; then \
		cp $(TOP_DIR)/Packshop/HI3520DV300/bin/dvrbox  $(WORK_DIR)/romfs/bin/ -rf ;	\
	fi	
	@if [ -e $(SOURCE_DIR)/Build/$(MAKE_DIR)/bin ]; then \
		cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/bin/*  $(WORK_DIR)/romfs/bin/ -rf ;	\
	fi

	@if [ -f $(SOURCE_DIR)/Build/$(MAKE_DIR)/bin/dvrbox_$(OEM_VENDOR_BUILD) ]; then \
		cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/bin/dvrbox_$(OEM_VENDOR_BUILD) $(WORK_DIR)/romfs/bin/dvrbox -rf; \
	fi

	@echo "拷贝iwpriv脚本"
	@if [ -f $(TOP_DIR)/Packshop/HI3520DV300/usr/sbin/iwpriv ]; then \
		cp $(TOP_DIR)/Packshop/HI3520DV300/usr/sbin/iwpriv  $(WORK_DIR)/romfs/sbin/ -rf ;	\
	fi
	
	@echo "拷贝动态库"
	@sudo tar -zxvf $(TOP_DIR)/Packshop/HI3520DV300/dynamic_lib.tgz -C $(WORK_DIR)/romfs/lib
	
	@echo "制作主Kernel"
	@if [ -f $(SOURCE_DIR)/Build/$(MAKE_DIR)/kernel/zImage ]; \
		then $(TOOL_DIR)/mkimage.hi3520 -A arm -O linux -T kernel -C none -a 0x80008000 \
		-e 0x80008000 -n linux -d $(SOURCE_DIR)/Build/$(MAKE_DIR)/kernel/zImage $(WORK_DIR)/romfs/boot/zImage.img;	\
	else \
		$(TOOL_DIR)/mkimage.hi3520 -A arm -O linux -T kernel -C none -a 0x80008000 \
		-e 0x80008000 -n linux -d $(TOP_DIR)/Packshop/HI3520DV300/kernel/zImage $(WORK_DIR)/romfs/boot/zImage.img;	\
	fi
	echo "$(WORK_DIR)/romfs/boot/zImage.img done"
	
	@echo "Start to make romfs-x.cramfs ..."
#	@$(TOOL_DIR)/mkcramfs $(WORK_DIR)/romfs $(TMP_DIST)/romfs-x.cramfs
	@rm $(TMP_DIST)/romfs-x.cramfs -f
	@$(TOOL_DIR)/mksquashfs $(WORK_DIR)/romfs $(TMP_DIST)/romfs-x.cramfs -processors 9 -b 256K -comp xz
	
	@if [ $$? -ne 0 ]; then								\
		echo "make romfs-x.cramfs fail!";				\
		exit 1;											\
	fi
	
	@echo ""
	@echo "Start to make romfs-x.cramfs.img ..."
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T kernel -C gzip -a 0x60000 \
	-e 0x440000 -n linux -d $(TMP_DIST)/romfs-x.cramfs $(TMP_DIST)/romfs-x.cramfs.img
	@if [ $$? -ne 0 ]; then								\
		echo "make romfs-x.cramfs.img fail.";			\
		exit 1;											\
	fi
		
	@echo "$(TMP_DIST)/romfs-x.cramfs.img done"

slvaimg:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	
	echo ""
	echo "Start to make slave uboot.bin.img ..."
	$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T firmware -C none -a 00000000 \
	-e 00000000 -n linux -d $(SOURCE_DIR)/Build/$(MAKE_DIR)/Slave/uboot/u-boot.bin $(TMP_DIST)/Slave/uboot.bin.img
	@cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/Slave/uboot/u-boot.bin $(TMP_DIST)/Slave/u-boot.bin
	@echo "$(TMP_DIST)/Slave/uboot.bin.img done"
	
slvinitrd:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	# 制作initrd文件
	
	# 删掉从片romfs-x.cramfs的中间文件
	@rm -fr $(WORK_DIR)/slvromfs/*
	tar -zxvf $(TOP_DIR)/Packshop/HI3515Slave/romfs.tgz -C $(WORK_DIR)/slvromfs

	# 拷贝从片应用程序
	@cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/Slave/App/slave  $(WORK_DIR)/slvromfs/usr/bin;
	
	@cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/Slave/etc/rcS  $(WORK_DIR)/slvromfs/etc/init.d
	@cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/Slave/etc/loadmod  $(WORK_DIR)/slvromfs/usr/etc
	
	# 拷贝从片应用程序
	@$(TOOL_DIR)/cpscript cpd $(SOURCE_DIR)/Build/$(MAKE_DIR)/Slave/Modules $(WORK_DIR)/slvromfs/usr/lib/modules;

	@echo "Start to make Slave romfs.cramfs ..."
	@$(TOOL_DIR)/mkcramfs $(WORK_DIR)/slvromfs $(TMP_DIST)/Slave/romfs.cramfs
	
	@if [ $$? -ne 0 ]; then								\
		echo "make romfs.cramfs fail!";					\
		exit 1;											\
	fi
	
	@echo ""
	@echo "Start to make romfs.cramfs.initrd ..."
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T ramdisk -C none -a 0xe3800000 \
	-e 0xe3800000 -n linux -d $(TMP_DIST)/Slave/romfs.cramfs $(TMP_DIST)/Slave/romfs.cramfs.initrd

	@if [ $$? -ne 0 ]; then										\
		echo "make $(TMP_DIST)/Slave/romfs.cramfs.initrd fail.";	\
		exit 1;													\
	fi
	@echo "$(TMP_DIST)/Slave/romfs.cramfs.initrd done"
	
	@echo ""
	@echo "Start to make romfs.cramfs.img ..."
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T standalone -C none -a 0xe3800000 \
	-e 0xe3800000 -n linux -d $(TMP_DIST)/Slave/romfs.cramfs.initrd $(TMP_DIST)/Slave/romfs.cramfs.initrd.img
	@if [ $$? -ne 0 ]; then										\
		echo "make $(TMP_DIST)/Slave/romfs.cramfs.initrd.img fail.";	\
		exit 1;													\
	fi
	echo "make $(TMP_DIST)/Slave/romfs.cramfs.initrd.img ok."
	
slvimg: slvaimg slvinitrd

	# 制作从片arm9安装包
	@if [ ! -d $(TMP_DIST)/tmpSlave ]; \
		then mkdir $(TMP_DIST)/tmpSlave; \
	else \
		rm -fr  $(TMP_DIST)/tmpSlave/*; \
	fi
	@cp -fr $(TOP_DIR)/Packshop/HI3515Slave/Arm9/* $(TMP_DIST)/tmpSlave
	@cp -fr $(TMP_DIST)/Slave/uboot.bin.img $(TMP_DIST)/tmpSlave
	@cp -fr $(TMP_DIST)/Slave/romfs.cramfs.initrd.img $(TMP_DIST)/tmpSlave
	
	$(TOOL_DIR)/mkcramfs $(TMP_DIST)/tmpSlave $(TMP_DIST)/Slave/slvfs-x.cramfs
	@if [ $$? -ne 0 ]; then										\
		echo "make $(TMP_DIST)/Slave/slvfs-x.cramfs fail.";	\
		exit 1;													\
	fi
	echo "make $(TMP_DIST)/Slave/slvfs-x.cramfs ok!"
	
	echo ""
	echo "Start to make $TARGET_FILE ..."
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T standalone -C none -a 0x81000000 \
	-e 0x82000000 -n linux -d $(TMP_DIST)/Slave/slvfs-x.cramfs $(TMP_DIST)/Slave/slvfs-x.cramfs.img
	@if [ $$? -ne 0 ]; then										\
		echo "make $(TMP_DIST)/Slave/slvfs-x.cramfs.img.";	\
		exit 1;													\
	fi
	echo "make $(TMP_DIST)/Slave/slvfs-x.cramfs.img ok."
		
# 制作usr升级包
uimg:

	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	
	@rm -fr $(WORK_DIR)/usr/*
	
	@mkdir $(WORK_DIR)/usr/bin	
	@cp $(shell pwd)/Custom/ProductDefinition $(WORK_DIR)/usr/bin
	@echo "拷贝通用的云台协议"
	@mkdir $(WORK_DIR)/usr/bin/Squirrel
	@mkdir $(WORK_DIR)/usr/bin/Squirrel/ptz
	$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Common/Squirrel/ptz $(WORK_DIR)/usr/bin/Squirrel/ptz

	@echo "拷贝通用的串口协议"
	@mkdir $(WORK_DIR)/usr/bin/Squirrel/comm
	$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Common/Squirrel/comm $(WORK_DIR)/usr/bin/Squirrel/comm
	
	@echo "拷贝通用的485协议"
	@mkdir $(WORK_DIR)/usr/bin/Squirrel/rs485
	$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Common/Squirrel/rs485 $(WORK_DIR)/usr/bin/Squirrel/rs485
	
	@echo "拷贝客户私有云台协议"
	@if [ -d $(TOP_DIR)/Squirrel/$(OEM_SQUIRREL)/ptz ]; then \
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Squirrel/$(OEM_SQUIRREL)/ptz $(WORK_DIR)/usr/bin/Squirrel/ptz; \
	fi

	@echo "拷贝客户私有485和串口协议"
	@if [ -d $(TOP_DIR)/Squirrel/$(OEM_SQUIRREL)/rs485 ]; then \
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Squirrel/$(OEM_SQUIRREL)/rs485 $(WORK_DIR)/usr/bin/Squirrel/rs485; \
	fi
		
ifneq ($(VERSION_FIX), R09)
ifneq ($(VERSION_FIX), R07)
	@echo "拷贝通用的前面板协议"
	@mkdir $(WORK_DIR)/usr/bin/Squirrel/pad
	$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Common/Squirrel/pad $(WORK_DIR)/usr/bin/Squirrel/pad
	
	@echo "拷贝通用的遥控器协议"
	@mkdir $(WORK_DIR)/usr/bin/Squirrel/remote
	$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Common/Squirrel/remote $(WORK_DIR)/usr/bin/Squirrel/remote
	
	@echo "拷贝通用的网络键盘协议"
	@mkdir $(WORK_DIR)/usr/bin/Squirrel/netkeyboard
	$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Common/Squirrel/netkeyboard $(WORK_DIR)/usr/bin/Squirrel/netkeyboard
	
	@echo "拷贝客户私有前面板协议"
	@if [ -d $(TOP_DIR)/Squirrel/$(OEM_SQUIRREL)/pad ]; then \
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Squirrel/$(OEM_SQUIRREL)/pad $(WORK_DIR)/usr/bin/Squirrel/pad; \
	fi
	
	@echo "拷贝客户私有遥控器协议"
	@if [ -d $(TOP_DIR)/Squirrel/$(OEM_SQUIRREL)/remote ]; then \
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Squirrel/$(OEM_SQUIRREL)/remote $(WORK_DIR)/usr/bin/Squirrel/remote; \
	fi
	
	@echo "拷贝客户私有网络键盘协议"
	@if [ -d $(TOP_DIR)/Squirrel/$(OEM_SQUIRREL)/netkeyboard ]; then \
		$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Squirrel/$(OEM_SQUIRREL)/netkeyboard $(WORK_DIR)/usr/bin/Squirrel/netkeyboard; \
	fi
endif
endif

	@echo "拷贝应用程序"
	@echo "Begin to rar $(SOFIA_TARGETDIR)/Sofia"
	@cp $(SOFIA_TARGETDIR)/Sofia $(WORK_DIR)/usr/bin
	#@cd $(WORK_DIR)/usr/bin;$(TOOL_DIR)/rar a $(WORK_DIR)/usr/bin/Sofia.rar ./Sofia
	@cd $(WORK_DIR)/usr/bin;tar --lzma -cvf $(WORK_DIR)/usr/bin/Sofia.tar.lzma ./Sofia
	@if [ $$? -ne 0 ]; then									\
        	echo "rar $(WORK_DIR)/usr/bin/Sofia.tar.lzma fail!";\
   	    	exit 1;											\
	fi
	@rm -fr $(WORK_DIR)/usr/bin/Sofia

	@mkdir $(WORK_DIR)/usr/etc
	$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Packshop/HI3520DV300/usr/etc $(WORK_DIR)/usr/etc;
	echo "拷贝loadmod脚本"
	cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/etc/loadmod  $(WORK_DIR)/usr/etc
	cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/etc/sysctl_asic.sh $(WORK_DIR)/usr/etc
	cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/etc/S81toe $(WORK_DIR)/usr/etc
	@mkdir $(WORK_DIR)/usr/share/
	@mkdir $(WORK_DIR)/usr/share/udhcpc/
	$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Packshop/HI3520D/usr/share/udhcpc/ $(WORK_DIR)/usr/share/udhcpc/
	
	if [ -f $(SOURCE_DIR)/Build/$(MAKE_DIR)/etc/auth.dat ]; then \
		cp $(SOURCE_DIR)/Build/$(MAKE_DIR)/etc/auth.dat $(WORK_DIR)/usr/etc;	\
	fi
	
ifeq ($(CGI_ON),true)
	@mkdir $(WORK_DIR)/usr/bin/cgi $(WORK_DIR)/usr/etc/cgi
	cd $(SOURCE_DIR)/Build/$(MAKE_DIR);tar --exclude-vcs --lzma -cvf $(WORK_DIR)/usr/bin/cgi.tar.lzma ./cgi/bin
	$(TOOL_DIR)/cpscript cpd $(SOURCE_DIR)/Build/$(MAKE_DIR)/cgi/etc $(WORK_DIR)/usr/etc/cgi
	ln -s /var/cgi/bin/cgibox   $(WORK_DIR)/usr/bin/cgi/login.cgi
	ln -s /var/cgi/bin/cgibox   $(WORK_DIR)/usr/bin/cgi/getability.cgi
	ln -s /var/cgi/bin/cgibox   $(WORK_DIR)/usr/bin/cgi/getinfo.cgi
	ln -s /var/cgi/bin/cgibox   $(WORK_DIR)/usr/bin/cgi/getlog.cgi
	ln -s /var/cgi/bin/cgibox   $(WORK_DIR)/usr/bin/cgi/opdev.cgi
	ln -s /var/cgi/bin/cgibox   $(WORK_DIR)/usr/bin/cgi/getconfig.cgi
	ln -s /var/cgi/bin/cgibox   $(WORK_DIR)/usr/bin/cgi/setconfig.cgi
	ln -s /var/cgi/bin/cgibox   $(WORK_DIR)/usr/bin/cgi/opptz.cgi
	ln -s /var/cgi/bin/cgibox   $(WORK_DIR)/usr/bin/cgi/usermanage.cgi
	
	echo "/usr/etc/cgi/boa_start.sh &" >> $(WORK_DIR)/usr/etc/loadmod
endif
	
	echo "拷贝WIFI脚本"
	@mkdir $(WORK_DIR)/usr/etc/Wireless
	@if [ -d $(SOURCE_DIR)/Build/$(MAKE_DIR)/etc/Wireless ]; then \
		$(TOOL_DIR)/cpscript cpd $(SOURCE_DIR)/Build/$(MAKE_DIR)/etc/Wireless  $(WORK_DIR)/usr/etc/Wireless; \
	fi
	
	@mkdir $(WORK_DIR)/usr/lib
	@mkdir $(WORK_DIR)/usr/lib/modules
	@$(TOOL_DIR)/cpscript cpd $(SOURCE_DIR)/Build/$(MAKE_DIR)/Modules $(WORK_DIR)/usr/lib/modules;
	@if [ -d $(SOURCE_DIR)/Build/$(MAKE_DIR)/Modules_$(OEM_VENDOR_BUILD) ]; then \
		$(TOOL_DIR)/cpscript cpd $(SOURCE_DIR)/Build/$(MAKE_DIR)/Modules_$(OEM_VENDOR_BUILD) $(WORK_DIR)/usr/lib/modules; \
	fi

ifeq ($(WIFI_MODULE),rt3070sta)
	rm -rf $(WORK_DIR)/usr/lib/modules/extdrv/mt7601Usta.ko
	rm -rf $(WORK_DIR)/usr/lib/modules/extdrv/mtprealloc7601Usta.ko
else
	rm -rf $(WORK_DIR)/usr/lib/modules/extdrv/rt3070sta.ko
	rm -rf $(WORK_DIR)/usr/lib/modules/extdrv/rtnet3070sta.ko
	rm -rf $(WORK_DIR)/usr/lib/modules/extdrv/rtutil3070sta.ko
endif

	#@cd $(WORK_DIR)/usr/lib;$(TOOL_DIR)/rar a $(WORK_DIR)/usr/lib/modules.rar ./modules
	@cd $(WORK_DIR)/usr/lib;tar --lzma -cvf ./modules.tar.lzma ./modules
	@if [ $$? -ne 0 ]; then									\
        	echo "rar $(WORK_DIR)/usr/lib/modules.tar.lzma fail!";\
   	    	exit 1;											\
	fi
	@rm -fr $(WORK_DIR)/usr/lib/modules
	
	@$(TOOL_DIR)/cpscript cpd $(SOURCE_DIR)/Build/$(MAKE_DIR)/dynamic $(WORK_DIR)/usr/lib/;
	
	@mkdir $(WORK_DIR)/usr/sbin
	@$(TOOL_DIR)/cpscript cpd $(TOP_DIR)/Packshop/HI3520DV300/usr/sbin $(WORK_DIR)/usr/sbin;
	@if [ -d $(SOURCE_DIR)/Build/$(MAKE_DIR)/usr/sbin ]; then \
		$(TOOL_DIR)/cpscript cpd $(SOURCE_DIR)/Build/$(MAKE_DIR)/usr/sbin $(WORK_DIR)/usr/sbin; \
	fi
	@chmod 777 $(WORK_DIR)/usr/sbin/*;
	@rm -fr $(WORK_DIR)/usr/sbin/iwpriv;
	@chown $(shell whoami):$(shell whoami) -R $(WORK_DIR)/usr
	@chmod 777 -R $(WORK_DIR)/usr

	@echo "Start to make user-x.cramfs ..."
#	@$(TOOL_DIR)/mkcramfs $(WORK_DIR)/usr $(TMP_DIST)/user-x.cramfs
	@rm $(TMP_DIST)/user-x.cramfs -f
	@$(TOOL_DIR)/mksquashfs $(WORK_DIR)/usr $(TMP_DIST)/user-x.cramfs -b 64K -comp xz
	@if [ $$? -ne 0 ]; then								\
		echo "make user-x.cramfs fail!";				\
		exit 1;											\
	fi
	
	@echo ""
	@echo "Start to make $user-x.cramfs.img ..."
	@$(TOOL_DIR)/mkimage.chklen -A arm -O linux -T kernel -C gzip -a 0x440000 \
	-e 0xb20000 -n linux -d $(TMP_DIST)/user-x.cramfs $(TMP_DIST)/user-x.cramfs.img
	@if [ $$? -ne 0 ]; then								\
		echo "make user-x.cramfs.img fail.";			\
		exit 1;											\
	fi

	@echo "$(TMP_DIST)/user-x.cramfs.img done"
	
calcDevID:
	@$(TOOL_DIR)/calcdevid.sh "$(WORK_DIR)" "$(OEM_ID)" "$(GUI_ID)" "$(BUILD_ID)" "$(WIFI_MODULE)" "$(TOP_DIR)"	"$(PRODUCTION_TYPE)" "$(DEVICEEXT_ID)" "$(SUB_NAME_FILE)" "$(ID_FILE)" "$(EXTID_CFG_FILE)"

logo: buildDir limg

web: buildDir wimg

custom: buildDir cimg

slave: buildDir slvimg

romfs: buildDir rimg

user: buildDir uimg

mtd: buildDir dimg

uboot: buildDir aimg

ubootall: buildDir u-allimg

ubootenv: buildDir u-envimg

pack: preBuild calcDevID limg cimg dimg aimg u-envimg wimg uimg rimg postBuild 

cid:
	@$(TOOL_DIR)/autoci.sh "$(BUILD_ROOT)" "$(COMM_FILE_LIST)" "$(NOTE_DIR)" "$(MD5_FILE_LIST)" "$(TOOL_DIR)" "$(SOFIA_INTERMEDIATEDIR)" "$(OEM_VENDOR)"

clean:
	@if [ $(WORK_Dir_BasName) != $(WORK_Dir_NeedName) ]; then \
		echo "<$(WORK_Dir_BasName)> ne <$(WORK_Dir_NeedName)>."; \
		exit 1; \
	fi
	rm -fr $(WORK_DIR)/*
	rm -rf $(SOFIA_INTERMEDIATEDIR)/*
