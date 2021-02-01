describe Nautilus::Utils::HexMath do
  it "check addition" do
    a = "01"
    b = "02"
    Nautilus::Utils::HexMath.add(a,b).should eq "03"
    Nautilus::Utils::HexMath.add(b,a).should eq "03"

    c = "0A"
    Nautilus::Utils::HexMath.add(a,c).should eq "0b"
    Nautilus::Utils::HexMath.add(c,a).should eq "0b"
    d = "0F"
    Nautilus::Utils::HexMath.add(c,d).should eq "19"
    Nautilus::Utils::HexMath.add(d,c).should eq "19"

    e = "19"
    Nautilus::Utils::HexMath.add(e,b).should eq "1b"
    Nautilus::Utils::HexMath.add(b,e).should eq "1b"

  end
end
