class WxmacAT31 < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"

  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.3/wxWidgets-3.1.3.tar.bz2"
  sha256 "fffc1d34dac54ff7008df327907984b156c50cff5a2f36ee3da6052744ab554a"
  head "https://github.com/wxWidgets/wxWidgets.git"

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      "--with-macosx-version-min=#{MacOS.version}",
      # Use standard C++ classes
      "--enable-stl",
      # Create static library
      "--disable-shared",
      # Enable compatibility with wxWidgets 2.8. This is required by Erlang's wx module
      "--enable-compat28",
    ]

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxmac's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxmac and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX
  end

  test do
    system bin/"wx-config", "--libs"
  end
end
