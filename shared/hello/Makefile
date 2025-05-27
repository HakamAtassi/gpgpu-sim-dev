GPGPU_SIM_DIR = ~/Repos/gpgpu-sim_distribution
GPGPU_SIM_CONFIGS_DIR = $(GPGPU_SIM_DIR)/configs/tested-cfgs
CONFIG = SM86_RTX3070
SETUP_ENVIRONMENT = release

TARGET = hello

CU_TARGET = $(TARGET).cu
SIM_TRACE = $(TARGET).txt

.PHONY: source-gpgpu-sim copy-config build run

setup:
	mkdir -p build

source-gpgpu-sim: # FIXME: automate and/or actually cause an error
	@echo "ERROR, GPGPU NOT SOURCED. PLEASE SOURCE THEN TRY AGAIN!"

copy-config: setup
	cp $(GPGPU_SIM_CONFIGS_DIR)/$(CONFIG)/* build/

build: setup
	nvcc -lcudart $(CU_TARGET) -o build/$(TARGET)

run:
	cd build && ./hello > ../$(SIM_TRACE)

all: source-gpgpu-sim copy-config build run

clean:
	rm -rf build/
	rm $(SIM_TRACE)