# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
#++

# On Linux, bin/setup installs PyPI's libclang wheel in vendor/libclang.
# The wheel has no copy of clang's built-in headers, such as stdbool.h,
# so bindgen searches the C compiler's last.
libclang = File.expand_path("../vendor/libclang/clang/native", __dir__)
if RUBY_PLATFORM.include?("linux") && File.directory?(libclang)
  ENV["LIBCLANG_PATH"] ||= libclang
  ENV["BINDGEN_EXTRA_CLANG_ARGS"] ||= "-idirafter #{`cc -print-file-name=include`.strip}"
end
