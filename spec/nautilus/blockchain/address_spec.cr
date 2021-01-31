describe Nautilus::Cryptography::Address do
  it "check address" do
    s = "218080f9dcaf43738584335ba3356b484826df86ddb601b1948fb2ec53715da3"
    sec = Sodium::Sign::SecretKey.new(bytes: s.to_slice)
    a = Nautilus::Cryptography::Address.new(pub_key: String.new(slice: sec.public_key.to_slice))
    a.to_address.should eq "Nxf19d018f3a493804f394afff4af0520c3465bf8b"
  end
end
