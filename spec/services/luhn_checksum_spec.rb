require 'spec_helper'
require_relative(File.join( SERVICES_PATH, 'luhn_checksum'))


RSpec.describe LuhnChecksum do


  describe 'valid?(x)' do

    it 'false for nil' do
      expect(described_class.valid?(nil)).to be_falsey
    end

    it 'false for an empty string' do
      expect(described_class.valid?('')).to be_falsey
    end

    it 'false for a string with no digits' do
      expect(described_class.valid?('just-letters')).to be_falsey
    end

    describe 'a string that looks like a number with a decimal' do

      describe 'true iff it valid?( the string as an integer with the decimal removed) == TRUE' do

      end

    end

    describe 'integers' do
      it 'valid?(0) TRUE' do
        expect(described_class.valid?(0)).to be_truthy
      end

      it 'valid?(49927398716) TRUE' do
        expect(described_class.compute(49927398716)).to be_truthy
      end

      it 'valid?(49927398717) FALSE' do
        expect(described_class.valid?(49927398717)).to be_falsey
      end

      it 'valid?(1234567812345678) FALSE' do
        expect(described_class.valid?(1234567812345678)).to be_falsey
      end

      it 'valid?(1234567812345670) TRUE' do
        expect(described_class.valid?(1234567812345670)).to be_truthy
      end

    end

    describe 'strings' do
      it "valid?('0') TRUE" do
        expect(described_class.valid?('0')).to be_truthy
      end

      it "valid?('49927398716') TRUE" do
        expect(described_class.compute('49927398716')).to be_truthy
      end

      it "valid?('49927398717') FALSE" do
        expect(described_class.valid?('49927398717')).to be_falsey
      end

      it "valid?('1234567812345678') FALSE" do
        expect(described_class.valid?('1234567812345678')).to be_falsey
      end

      it "valid?('1234567812345670') TRUE" do
        expect(described_class.valid?('1234567812345670')).to be_truthy
      end

    end

  end


  describe 'compute(x)' do

    it '1 for nil' do
      expect(described_class.compute(nil)).to eq 1
    end

    it '1 for an empty string' do
      expect(described_class.compute('')).to eq 1
    end

    it '1 for a string with no digits' do
      expect(described_class.compute('just-letters')).to eq 1
    end


    describe 'a string that looks like a number with a decimal' do

      describe 'true iff it luhn_checksum?( the string as an integer with the decimal removed) == TRUE' do

        it "compute(('.100') = 1" do
          expect(described_class.compute('.100')).to eq 1
        end
        it "compute(('1.00') = 1" do
          expect(described_class.compute('1.00')).to eq 1
        end
        it "compute(('10.0') = 1" do
          expect(described_class.compute('10.0')).to eq 1
        end
        it "compute(('100.') = 1" do
          expect(described_class.compute('100.')).to eq 1
        end


        it "compute(('4.9927398716') = 70" do
          expect(described_class.compute('4.9927398716')).to eq 70
        end
        it "valid?('4.9927398716') = TRUE" do
          expect(described_class.valid?('4.9927398716')).to be_truthy
        end

      end

    end


    it 'compute((0) = 0' do
      expect(described_class.compute(0)).to eq 0
    end
    it "compute(('0') = 0" do
      expect(described_class.compute('0')).to eq 0
    end

    it "compute((100) = 1" do
      expect(described_class.compute(100)).to eq 1
    end
    it "compute(('100') = 1" do
      expect(described_class.compute('100')).to eq 1
    end
    it "compute(('0100') = 1" do
      expect(described_class.compute('0100')).to eq 1
    end

    it 'compute((49927398716) = 70' do
      expect(described_class.compute(49927398716)).to eq 70
    end
    it "compute(('49927398716') = 70" do
      expect(described_class.compute('49927398716')).to eq 70
    end

    it 'compute((1234567812345678) = 8' do
      expect(described_class.compute(1234567812345678)).not_to eq 8
    end
    it "compute(('1234567812345678') = 8" do
      expect(described_class.compute('1234567812345678')).not_to eq 8
    end

    it "compute((1234567812345670) = 60" do
      expect(described_class.compute(1234567812345670)).to eq 60
    end

    it "compute(('1234567812345670') = 60" do
      expect(described_class.compute('1234567812345670')).to eq 60
    end

  end


end

