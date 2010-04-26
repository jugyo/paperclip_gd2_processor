require 'test_helper'

class PaperclipGd2ProcessorTest < ActiveSupport::TestCase
  should 'parse_geometry で geometry の文字列をパースできる' do
    assert_equal 0.5, Paperclip::Gd2Thumbnail.parse_geometry('50%')
    assert_equal [100, 100], Paperclip::Gd2Thumbnail.parse_geometry('100x100')
    assert_raise(ArgumentError) { Paperclip::Gd2Thumbnail.parse_geometry('100x10a') }
    assert_raise(ArgumentError) { Paperclip::Gd2Thumbnail.parse_geometry('a') }
  end

  context 'Gd2Thumbnail.new' do
    setup do
      @filename = File.join(File.dirname(__FILE__), 'fixtures/files/test.jpg')
      @file = File.new(@filename)
      @options = {:geometry => '100x100#'}
      @attachment_stub = Object.new
      stub(@attachment_stub).path {'test.jpg'}
      @gd2_thumbnail = Paperclip::Gd2Thumbnail.new(@file, @options, @attachment_stub)
    end

    should 'インスタンス変数に値がセットされていること' do
      assert_equal [100, 100], @gd2_thumbnail.instance_eval{@geometry}
      assert_equal @file, @gd2_thumbnail.instance_eval{@file}
      assert_equal true, @gd2_thumbnail.instance_eval{@crop}
      assert_equal 'test.jpg', @gd2_thumbnail.instance_eval{@basename}
    end
  end

  context 'crop => true' do
    setup do
      @filename = File.join(File.dirname(__FILE__), 'fixtures/files/test.jpg')
      @file = File.new(@filename)
      @options = {:geometry => '100x100#'}
      stub(@attachment_stub).path {'test.jpg'}
      @gd2_thumbnail = Paperclip::Gd2Thumbnail.new(@file, @options, @attachment_stub)
    end

    should 'make を呼ぶとサムネイルが作成される 100x100' do
      dst_file = @gd2_thumbnail.make
      image = GD2::Image.import(dst_file.path)
      assert_equal 100, image.width
      assert_equal 100, image.height
    end
  end

  context 'crop => false' do
    setup do
      @filename = File.join(File.dirname(__FILE__), 'fixtures/files/test.jpg')
      @file = File.new(@filename)
      @options = {:geometry => '100x100'}
      stub(@attachment_stub).path {'test.jpg'}
      @gd2_thumbnail = Paperclip::Gd2Thumbnail.new(@file, @options, @attachment_stub)
    end

    should 'make を呼ぶとサムネイルが作成される ?x100 (縦幅が100x100に収まるようにリサイズされる)' do
      dst_file = @gd2_thumbnail.make
      image = GD2::Image.import(dst_file.path)
      assert_not_equal 100, image.width
      assert_equal 100, image.height
    end
  end

  context 'scale => true' do
    setup do
      @filename = File.join(File.dirname(__FILE__), 'fixtures/files/test.jpg')
      @file = File.new(@filename)
      @options = {:geometry => '50%'}
      stub(@attachment_stub).path {'test.jpg'}
      @gd2_thumbnail = Paperclip::Gd2Thumbnail.new(@file, @options, @attachment_stub)
    end

    should 'make を呼ぶとサムネイルが作成される ?x100 (縦幅が100x100に収まるようにリサイズされる)' do
      dst_file = @gd2_thumbnail.make
      original_image = GD2::Image.import(@filename)
      image = GD2::Image.import(dst_file.path)
      assert_equal (original_image.width * 0.5).floor, image.width
      assert_equal (original_image.height * 0.5).floor, image.height
    end
  end
end
