class MainLine < Formula
    desc "A command line tool for automating your LinuxMain.swift file"
    homepage "https://github.com/eman6576/MainLine"
    url "https://github.com/eman6576/Mint/archive/1.0.0.tar.gz"
    sha256 ""
    head "https://github.com/eman6576/Mint.git"
  
    depends_on :xcode
  
    def install
      system "make", "install", "PREFIX=#{prefix}"
    end
  end