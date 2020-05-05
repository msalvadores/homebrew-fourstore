require 'formula'

class FourstoreNcbo < Formula
  homepage 'http://4store.org/'

  if build.include? 'ncbo'
    head 'git://github.com/ncbo/4store.git'
  else
    url 'http://github.com/garlik/4store/archive/v1.1.5.tar.gz'
    head 'git@github.com:garlik/4store.git'
    sha256 '5420a048b5e7c5abc5a95f24ab17ab4c9b90bc012dbf97e16aeab07f095aa102'
  end

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :build
  depends_on 'glib'
  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'pcre'

  if build.head?
    depends_on "gettext"
    depends_on "autogen"
    depends_on "autoconf"
    depends_on "automake"
  end

  def install
    args  = ["--prefix=#{prefix}",
            "--with-storage-path=#{var}/fourstore",
            ]
    if build.head? then
      require "Date"
      system "echo '#{DateTime.now.to_s}--trunk' > ./.version"
      system "./autogen.sh --verbose"
    end
    system "./configure", *args
    system "make install"
  end

  def caveats; <<~EOS
    Databases will be created at #{var}/fourstore.

    Create and start up a database:
        4s-backend-setup mydb
        4s-backend mydb

    Load RDF data:
        4s-import mydb datafile.rdf

    Start up HTTP SPARQL server without daemonizing:
        4s-httpd -p 8000 -D mydb

    See http://github.com/garlik/4store for more information.
    EOS
  end

end
