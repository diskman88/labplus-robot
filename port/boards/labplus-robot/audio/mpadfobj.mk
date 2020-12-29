
################################################################################
# List of object files from the ESP32 ADF components
# 相关修改：
#   1、board及音频驱动相关的代码放在adf-port/board下.
# 	   不再编译esp-adf/components/audio_board 及 esp-adf/components/audio_hal下内容。
#      硬件的相关引脚做些修改，ES8388的I2C驱动用在mpython已初始化，驱动需做些修改。
#   2、按需要添加/删减一些adf模块。
#   3、adf需要一些idf componets，但大部分已在mpython项目的makefile中添加，这里把重复的注释。
#   4、对文件系统的操作都放在micropython层面。
#   5、除了codec芯片，其它的硬件驱动不需要。
#   6、添加dueros音箱功能。

# ifdef CONFIG_ESP_LYRAT_V4_3_BOARD
# ESPADF_AUDIO_BOARD_O = $(patsubst %.c,%.o,$(wildcard $(ADFCOMP)/audio_board/lyrat_v4_3/*.c))
# endif
# ifdef CONFIG_ESP_LYRAT_V4_2_BOARD
# ESPADF_AUDIO_BOARD_O = $(patsubst %.c,%.o,$(wildcard $(ADFCOMP)/audio_board/lyrat_v4_2/*.c))
# endif
# ifdef CONFIG_ESP_LYRATD_MSC_V2_1_BOARD
# ESPADF_AUDIO_BOARD_O = $(patsubst %.c,%.o,$(wildcard $(ADFCOMP)/audio_board/lyratd_msc_v2_1/*.c))
# endif
# ifdef CONFIG_ESP_LYRATD_MSC_V2_2_BOARD
# ESPADF_AUDIO_BOARD_O = $(patsubst %.c,%.o,$(wildcard $(ADFCOMP)/audio_board/lyratd_msc_v2_2/*.c))
# endif
# ifdef CONFIG_ESP_LYRAT_MINI_V1_1_BOARD
# ESPADF_AUDIO_BOARD_O = $(patsubst %.c,%.o,$(wildcard $(ADFCOMP)/audio_board/lyrat_mini_v1_1/*.c))
# endif
ESPADF_AUDIO_HAL_O = $(patsubst %.c,%.o, \
	$(wildcard $(ADFCOMP)/audio_hal/*.c) \
	)

ESPADF_AUDIO_BOARD_O = $(patsubst %.c,%.o,$(wildcard $(AUDIO)/driver/*.c)) #使用修改后的硬件驱动。

ESPADF_ADF_UTILS_O = $(patsubst %.c,%.o, \
	$(wildcard $(ADFCOMP)/adf_utils/cloud_services/*.c) \
	$(wildcard $(ADFCOMP)/adf_utils/*.c) \
	)

ESPADF_AUDIO_PIPELINE_O = $(patsubst %.c,%.o,$(wildcard $(ADFCOMP)/audio_pipeline/*.c))

ESPADF_AUDIO_SAL_O = $(patsubst %.c,%.o,$(wildcard $(ADFCOMP)/audio_sal/*.c))

ESPADF_AUDIO_STREAM_O = $(patsubst %.c,%.o,\
	$(ADFCOMP)/audio_stream/http_stream.c \
	$(ADFCOMP)/audio_stream/i2s_stream.c \
	$(ADFCOMP)/audio_stream/raw_stream.c \
	$(ADFCOMP)/audio_stream/hls_playlist.c \
	)

ESPADF_DISPLAY_SERVICE_O = $(patsubst %.c,%.o,\
	$(wildcard $(ADFCOMP)/display_service/*.c) \
	$(wildcard $(ADFCOMP)/display_service/led_indicator/*.c) \
	)

ESPADF_ESP_DISPATCHER_O = $(patsubst %.c,%.o,$(wildcard $(ADFCOMP)/esp_dispatcher/*.c))

ESPADF_ESP_PERIPHERALS_O = $(patsubst %.c,%.o,\
	$(ADFCOMP)/esp_peripherals/esp_peripherals.c \
	$(ADFCOMP)/esp_peripherals/periph_button.c \
	$(ADFCOMP)/esp_peripherals/periph_led.c \
	$(ADFCOMP)/esp_peripherals/lib/button/button.c \
	)
	# $(ADFCOMP)/esp_peripherals/periph_ws2812.c 

ESPADF_LIBS_O = $(patsubst %.c,%.o, \
	$(wildcard $(ADFCOMP)/esp-adf-libs/esp_codec/*.c) \
	$(wildcard $(ADFCOMP)/esp-adf-libs/audio_misc/*.c) \
	)

ESPIDF_PLAYLIST_O = $(patsubst %.c,%.o, \
	$(wildcard $(ADFCOMP)/playlist/*.c) \
	$(wildcard $(ADFCOMP)/playlist/playlist_operator/*.c) \
	$(wildcard $(ADFCOMP)/playlist/sdcard_scan/*.c) \
	)

ESPADF_SERVICE_O = $(patsubst %.c,%.o, \
	$(wildcard $(AUDIO)/lib/dueros/*.c) \
	$(wildcard $(AUDIO)/lib/dueros/dueros_service/*.c) \
	)

ESPADF_STREAM_O = $(patsubst %.c,%.o, \
	$(wildcard $(AUDIO)/lib/stream/*.c) \
	)

$(eval $(call gen_espidf_lib_rule,audio_board,$(ESPADF_AUDIO_BOARD_O)))
$(eval $(call gen_espidf_lib_rule,audio_hal,$(ESPADF_AUDIO_HAL_O)))
$(eval $(call gen_espidf_lib_rule,audio_pipeline,$(ESPADF_AUDIO_PIPELINE_O)))
$(eval $(call gen_espidf_lib_rule,audio_sal,$(ESPADF_AUDIO_SAL_O)))
$(eval $(call gen_espidf_lib_rule,adf_utils,$(ESPADF_ADF_UTILS_O)))
$(eval $(call gen_espidf_lib_rule,audio_stream,$(ESPADF_AUDIO_STREAM_O)))
$(eval $(call gen_espidf_lib_rule,display_service,$(ESPADF_DISPLAY_SERVICE_O)))
$(eval $(call gen_espidf_lib_rule,esp_dispatcher,$(ESPADF_ESP_DISPATCHER_O)))
$(eval $(call gen_espidf_lib_rule,esp_peripherals,$(ESPADF_ESP_PERIPHERALS_O)))
$(eval $(call gen_espidf_lib_rule,esp-adf-libs,$(ESPADF_LIBS_O)))
$(eval $(call gen_espidf_lib_rule,esp-idf-playlist,$(ESPIDF_PLAYLIST_O)))
$(eval $(call gen_espidf_lib_rule,service,$(ESPADF_SERVICE_O)))
$(eval $(call gen_espidf_lib_rule,stream,$(ESPADF_STREAM_O)))

################################################################################
# List of object files from the ESP32 IDF components which are needed by ADF components

# ESPIDF_HTTP_CLIENT_O = $(patsubst %.c,%.o, 
# 	$(wildcard $(ESPCOMP)/esp_http_client/*.c) 
# 	$(wildcard $(ESPCOMP)/esp_http_client/lib/*.c) 
# 	)

# ESPIDF_SPIFFS_O = $(patsubst %.c,%.o,$(wildcard $(ESPCOMP)/spiffs/spiffs/src/*.c))

# ESPIDF_FATFS_O = $(patsubst %.c,%.o,$(wildcard $(ESPCOMP)/fatfs/src/*.c))

ESPIDF_ADC_CAL_O = $(patsubst %.c,%.o,$(wildcard $(ESPCOMP)/esp_adc_cal/*.c))

# ESPIDF_WEAR_LEVELLING_O = $(patsubst %.cpp,%.o,$(wildcard $(ESPCOMP)/wear_levelling/*.cpp))

# ESPIDF_TCP_TRANSPORT_O = $(patsubst %.c,%.o,$(wildcard $(ESPCOMP)/tcp_transport/*.c))

# ESPIDF_ESP_TLS_O = $(patsubst %.c,%.o,$(wildcard $(ESPCOMP)/esp-tls/*.c))

# ESPIDF_ESP_NGHTTP = $(patsubst %.c,%.o,$(wildcard $(ESPCOMP)/nghttp/port/*.c))

ESPIDF_JSMN_O = $(patsubst %.c,%.o,$(wildcard $(ESPCOMP)/jsmn/src/*.c))

# $(eval $(call gen_espidf_lib_rule,esp_http_client,$(ESPIDF_HTTP_CLIENT_O)))
# $(eval $(call gen_espidf_lib_rule,spiffs,$(ESPIDF_SPIFFS_O)))
# $(eval $(call gen_espidf_lib_rule,fatfs,$(ESPIDF_FATFS_O)))
$(eval $(call gen_espidf_lib_rule,esp_adc_cal,$(ESPIDF_ADC_CAL_O)))
# $(eval $(call gen_espidf_lib_rule,wear_levelling,$(ESPIDF_WEAR_LEVELLING_O)))
# $(eval $(call gen_espidf_lib_rule,tcp_transport,$(ESPIDF_TCP_TRANSPORT_O)))
# $(eval $(call gen_espidf_lib_rule,esp_tls,$(ESPIDF_ESP_TLS_O)))
# $(eval $(call gen_espidf_lib_rule,nghttp,$(ESPIDF_ESP_NGHTTP)))
$(eval $(call gen_espidf_lib_rule,esp_jsmn,$(ESPIDF_JSMN_O)))
