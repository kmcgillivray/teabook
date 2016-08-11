require_relative '../models/entry'

RSpec.describe Entry do
  describe "attributes" do
    let(:entry) { Entry.new('Sencha', 'Green', 'Kyusu') }

    it "responds to tea name" do
      expect(entry).to respond_to(:tea_name)
    end

    it "reports its name" do
      expect(entry.tea_name).to eq('Sencha')
    end

    it "responds to type" do
      expect(entry).to respond_to(:type)
    end

    it "reports its type" do
      expect(entry.type).to eq('Green')
    end

    it "responds to brewing method" do
      expect(entry).to respond_to(:brewing_method)
    end

    it "reports its brewing method" do
      expect(entry.brewing_method).to eq('Kyusu')
    end
  end

  describe "#to_s" do
    it "prints an entry as a string" do
      entry = Entry.new('Sencha', 'Green', 'Kyusu')
      expected_string = "Tea Name: Sencha\nType: Green\nBrewing Method: Kyusu"
      expect(entry.to_s).to eq(expected_string)
    end
  end
end
