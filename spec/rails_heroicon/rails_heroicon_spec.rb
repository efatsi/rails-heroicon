RSpec.describe RailsHeroicon::RailsHeroicon do
  describe "#initialize" do
    it "sets the icon name" do
      icon = RailsHeroicon::RailsHeroicon.new("user")

      expect(icon.instance_variable_get(:@icon)).to eq("user")
    end

    it "sets the default variant type to outline" do
      icon = RailsHeroicon::RailsHeroicon.new("user")

      expect(icon.instance_variable_get(:@variant)).to eq("outline")
    end

    it "sets the variant type" do
      icon = RailsHeroicon::RailsHeroicon.new("user", variant: :solid)

      expect(icon.instance_variable_get(:@variant)).to eq("solid")
    end

    it "sets the size" do
      icon = RailsHeroicon::RailsHeroicon.new("user", size: 24)

      expect(icon.instance_variable_get(:@size)).to eq(24)
    end

    it "raises if variant is undefined" do
      expect do
        RailsHeroicon::RailsHeroicon.new("user", variant: "unknown")
      end.to raise_error(RailsHeroicon::UndefinedVariant, "Variant should be one of outline, solid")
    end
  end

  describe "#svg_path" do
    it "raise error if icon is not found" do
      icon = RailsHeroicon::RailsHeroicon.new("fooicon")

      expect { icon.svg_path }.to raise_error(RailsHeroicon::UndefinedIcon, "Couldn't find icon for fooicon")
    end

    it "sets the icon" do
      icon = RailsHeroicon::RailsHeroicon.new("user")

      expect(icon.svg_path).to match(/path/)
    end

    it "sets the svg version" do
      icon = RailsHeroicon::RailsHeroicon.new("user")

      expect(icon.options[:version]).to eq("1.1")
    end

    it "sets the html attributes passed" do
      icon = RailsHeroicon::RailsHeroicon.new("user", class: "text-red-600")

      expect(icon.options[:class]).to eq("text-red-600")
    end

    it "does not have the variant attribute" do
      icon = RailsHeroicon::RailsHeroicon.new("user", variant: "outline")

      expect(icon.options.key?("variant")).to be_falsy
    end

    it "does not have the size attribute" do
      icon = RailsHeroicon::RailsHeroicon.new("user", size: 24)

      expect(icon.options.key?("size")).to be_falsy
    end

    context "when being an outline variant" do
      it "does not have the stroke attribute" do
        icon = RailsHeroicon::RailsHeroicon.new("user", variant: "outline")

        expect(icon.svg_path).not_to match(/stroke=/)
      end

      it "has the fill attribute" do
        icon = RailsHeroicon::RailsHeroicon.new("truck", variant: "outline")

        expect(icon.svg_path).to match(/fill=/)
      end
    end

    context "when being a solid variant" do
      it "does not have the fill attribute" do
        icon = RailsHeroicon::RailsHeroicon.new("user", variant: "solid")

        expect(icon.svg_path).not_to match(/fill=/)
      end

      it "has the stroke attribute" do
        icon = RailsHeroicon::RailsHeroicon.new("folder-add", variant: "solid")

        expect(icon.svg_path).to match(/stroke=/)
      end
    end
  end

  describe "fill and stroke" do
    it "sets the stroke to currentColor and fill as none if variant is outline" do
      icon = RailsHeroicon::RailsHeroicon.new("user", variant: "outline")

      expect(icon.options[:stroke]).to eq("currentColor")
      expect(icon.options[:fill]).to eq("none")
    end

    it "sets the stroke to none and fill as currentColor if variant is solid" do
      icon = RailsHeroicon::RailsHeroicon.new("user", variant: "solid")

      expect(icon.options[:stroke]).to eq("none")
      expect(icon.options[:fill]).to eq("currentColor")
    end
  end

  describe "accessibility" do
    it "sets aria-hidden to true if aria-label is not passed" do
      icon = RailsHeroicon::RailsHeroicon.new("user")

      expect(icon.options[:"aria-hidden"]).to eq("true")
    end

    it "sets role to img if aria-label is passed" do
      icon = RailsHeroicon::RailsHeroicon.new("user", "aria-label": "icon")

      expect(icon.options.key?("aria-hidden")).to be_falsy
      expect(icon.options[:role]).to eq("img")

      another_icon = RailsHeroicon::RailsHeroicon.new("user", aria: { label: "icon" })

      expect(another_icon.options.key?("aria-hidden")).to be_falsy
      expect(another_icon.options[:role]).to eq("img")
    end
  end

  describe "viewBox" do
    it "sets the viewBox to 24 if variant is outline" do
      icon = RailsHeroicon::RailsHeroicon.new("user", variant: "outline")

      expect(icon.options[:viewBox]).to eq("0 0 24 24")
    end

    it "sets the viewBox to 20 if variant is solid" do
      icon = RailsHeroicon::RailsHeroicon.new("user", variant: "solid")

      expect(icon.options[:viewBox]).to eq("0 0 20 20")
    end
  end

  describe "sizes" do
    it "size defaults to 24 if variant is outline" do
      icon = RailsHeroicon::RailsHeroicon.new("user", variant: "outline")

      expect(icon.options[:height]).to eq(24)
      expect(icon.options[:width]).to eq(24)
    end

    it "size does not default to 24 if user has explicitly stated" do
      icon = RailsHeroicon::RailsHeroicon.new("user", variant: "outline", size: 20)

      expect(icon.options[:height]).to eq(20)
      expect(icon.options[:width]).to eq(20)
    end

    it "size defaults to 20 if variant is solid" do
      icon = RailsHeroicon::RailsHeroicon.new("user", variant: "solid")

      expect(icon.options[:height]).to eq(20)
      expect(icon.options[:width]).to eq(20)
    end

    it "size does not default to 20 if user has explicitly stated" do
      icon = RailsHeroicon::RailsHeroicon.new("user", variant: "solid", size: 24)

      expect(icon.options[:height]).to eq(24)
      expect(icon.options[:width]).to eq(24)
    end
  end
end
