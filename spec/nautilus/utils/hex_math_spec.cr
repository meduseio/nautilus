describe Nautilus::Utils::HexMath do
  it "check addition" do
    a = "1"
    b = "2"
    Nautilus::Utils::HexMath.add(a,b).should eq "3"
    Nautilus::Utils::HexMath.add(b,a).should eq "3"

    c = "A"
    Nautilus::Utils::HexMath.add(a,c).should eq "B"
    Nautilus::Utils::HexMath.add(c,a).should eq "B"
    d = "F"
    Nautilus::Utils::HexMath.add(c,d).should eq "19"
    Nautilus::Utils::HexMath.add(d,c).should eq "19"

    e = "19"
    Nautilus::Utils::HexMath.add(e,b).should eq "1B"
    puts b
    puts e
    Nautilus::Utils::HexMath.add(b,e).should eq "1B"

  end
end
