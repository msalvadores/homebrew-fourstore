require 'formula'

class FourstoreNcbo < Formula
  desc "Fourstore RDF database, customized for BioPortal"
  homepage "https://github.com/ncbo/4store"
  url "https://github.com/ncbo/4store/archive/v1.1.6-NCBO-SNAPSHOT-1.tar.gz"
  head "git@github.com:ncbo/4store.git"
  sha256 "1da20d132065ce6d12df5de2b3423d719680259822ada0029132b571df031745"
  revision 1

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "autogen"
  depends_on "gettext"
  depends_on "glib"
  depends_on "pcre"
  depends_on "raptor"
  depends_on "rasqal"

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
