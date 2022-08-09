# frozen_string_literal: true

RSpec.describe KSUID::Base62 do
  describe '#compatible?' do
    it 'correctly detects invalid values in a string' do
      expect(KSUID::Base62.compatible?('15Ew2nYeRDscBipuJicYjl970D1')).to be true
      expect(KSUID::Base62.compatible?(("\xFF" * 20).b)).not_to be true
    end
  end

  describe '#decode' do
    it 'decodes base 62 numbers that may or may not be zero-padded' do
      %w[awesomesauce 00000000awesomesauce].each do |encoded|
        decoded = KSUID::Base62.decode(encoded)

        expect(decoded).to eq(1_922_549_000_510_644_890_748)
      end
    end

    it 'decodes zero' do
      encoded = '0'

      decoded = KSUID::Base62.decode(encoded)

      expect(decoded).to eq(0)
    end

    it 'decodes numbers that are longer than 20 digits' do
      encoded = '01234567890123456789'

      decoded = KSUID::Base62.decode(encoded)

      expect(decoded).to eq(189_310_246_048_642_169_039_429_477_271_925)
    end

    it 'does bad things for words that are not base 62' do
      expect { KSUID::Base62.decode('this should break!') }.to raise_error(ArgumentError)
    end
  end

  describe '#encode' do
    it 'encodes numbers into 27-digit base 62' do
      number = 1_922_549_000_510_644_890_748

      encoded = KSUID::Base62.encode(number)

      expect(encoded).to eq('000000000000000awesomesauce')
    end

    it 'encodes negative numbers as zero' do
      number = -1

      encoded = KSUID::Base62.encode(number)

      expect(encoded).to eq('000000000000000000000000000')
    end
  end

  describe '#encode_bytes' do
    it 'encodes byte strings' do
      bytes = "\xFF" * 4

      encoded = KSUID::Base62.encode_bytes(bytes)

      expect(encoded).to eq('0000000000000000000004gfFC3')
    end

    it 'encodes byte arrays' do
      bytes = [255] * 4

      encoded = KSUID::Base62.encode_bytes(bytes)

      expect(encoded).to eq('0000000000000000000004gfFC3')
    end
  end
end
