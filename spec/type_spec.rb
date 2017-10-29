# frozen_string_literal: true

RSpec.describe Ksuid::Type do
  describe '.from_base62' do
    it 'converts a base62 KSUID properly' do
      ksuid = Ksuid.from_base62(Ksuid::MAX_STRING_ENCODED)

      expect(ksuid).to eq(Ksuid::Max)
    end
  end

  describe '#<=>' do
    it 'sorts the KSUIDs by timestamp' do
      ksuid1 = Ksuid.new(time: Time.at(123))
      ksuid2 = Ksuid.new(time: Time.at(234))

      array = [ksuid2, ksuid1].sort

      expect(array).to eq([ksuid1, ksuid2])
    end
  end

  describe '#payload' do
    it 'returns the payload as a byte string' do
      expected = ("\xFF" * 16).bytes

      array = Ksuid::Max.payload.bytes

      expect(array).to eq(expected)
    end
  end

  describe '#to_bytes' do
    it 'returns the ksuid as a byte string' do
      expected = ("\xFF" * 20).bytes

      array = Ksuid::Max.to_bytes.bytes

      expect(array).to eq(expected)
    end
  end

  describe '#to_time' do
    it 'returns the times used to create the ksuid' do
      time = Time.at(Time.now.to_i)

      ksuid = Ksuid.new(time: time)

      expect(ksuid.to_time).to eq(time)
    end
  end

  describe '#to_s' do
    it 'correctly represents the maximum value' do
      expect(Ksuid::Max.to_s).to eq(Ksuid::MAX_STRING_ENCODED)
    end

    it 'correctly represents zero' do
      expected = '0' * 27

      string = Ksuid.from_bytes([0] * 20).to_s

      expect(string).to eq(expected)
    end
  end
end
