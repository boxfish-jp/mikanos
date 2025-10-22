#pragma once

//clang-format off
#include "graphics.hpp"
#include <cstdint>
//clang-format on

void WriteAscii(PixelWriter &writer, int x, int y, char c,
                const PixelColor &color);
