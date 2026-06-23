# Если через переменные окружения при запуске make не задано иное, то использовать g++ как компилятор.
# (Кстати, нельзя эту переменную назвать CPP, потому что она для make предопределена значением "cc".)
CXX            ?= g++
CXXFLAGS       += -Doff64_t=off_t -Dlseek64=lseek -Dftruncate64=ftruncate -D_GNU_SOURCE

MSYS2_BIN_DIR  ?= $(shell cygpath -m /usr/bin)
DIST_DIR       ?= dist

VERSION         = $(shell git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")

# libsparse
LIB_NAME        = sparse
SLIB            = lib$(LIB_NAME).a
LIB_SRCS        = \
				  backed_block.cpp \
				  output_file.cpp \
				  sparse.cpp \
				  sparse_crc32.cpp \
				  sparse_err.cpp \
				  sparse_fuzzer.cpp \
				  sparse_read.cpp \
				  android-base/mapped_file.cpp \
				  android-base/stringprintf.cpp
LIB_OBJS        = $(LIB_SRCS:%.cpp=%.o)

LDFLAGS        += -L. -l$(LIB_NAME) -lz -static

# Перечисляем exe-шники, которые будем собирать.
BINS            = simg2img.exe img2simg.exe append2simg.exe

# Каталоги заголовочных файлов вне папки проекта (папки рекурсивно не перебираются).
LIB_INCS        = -Iinclude -Iandroid-base/include

# simg2img
SIMG2IMG_SRC    = simg2img.cpp

# img2simg
IMG2SIMG_SRC    = img2simg.cpp

# append2simg
APPEND2SIMG_SRC = append2simg.cpp

# Запрещаем использовать наличие данных папок как признак, что одноименные цели для make уже выполнены.
.PHONY: default all clean dist

# Цели make:
default: all
all: $(BINS)

%.o: %.cpp
		$(CXX) $(CXXFLAGS) $(LIB_INCS) -c $< -o $@

$(SLIB): $(LIB_OBJS)
		# Создание архива (без сжатия) совокупности объектных файлов всех библиотек.
		ar rc $(SLIB) $(LIB_OBJS)
		# Индексация (по сути, создание оглавления) для архива библиотек. Писать эту строчку не обязательно, потому что современные версии ar делают это по умолчанию сами.
		ranlib $(SLIB)

simg2img.exe: $(SIMG2IMG_SRC) $(SLIB)
		$(CXX) $(CXXFLAGS) $(LIB_INCS) $< -o $@ $(LDFLAGS)

img2simg.exe: $(IMG2SIMG_SRC) $(SLIB)
		$(CXX) $(CXXFLAGS) $(LIB_INCS) $< -o $@ $(LDFLAGS)

append2simg.exe: $(APPEND2SIMG_SRC) $(SLIB)
		$(CXX) $(CXXFLAGS) $(LIB_INCS) $< -o $@ $(LDFLAGS)

clean:
		$(RM) $(BINS) $(LIB_OBJS) $(SLIB)
		$(RM) -r $(DIST_DIR)

dist: $(BINS)
		mkdir -p $(DIST_DIR)
		zip -j $(DIST_DIR)/android-libsparse-win-$(VERSION).zip $(BINS) $(MSYS2_BIN_DIR)/msys-2.0.dll simg_dump.py