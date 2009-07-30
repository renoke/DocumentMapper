# --
# Copyright (C) 2008-2009 10gen Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ++

# A byte buffer.
class ByteBuffer

  attr_reader :order

  def initialize(initial_data=[])
    @buf = initial_data
    @cursor = 0
    self.order = :little_endian
  end

  # +endianness+ should be :little_endian or :big_endian. Default is :little_endian
  def order=(endianness)
    @order = endianness
    @int_pack_order = endianness == :little_endian ? 'V' : 'N'
    @double_pack_order = endianness == :little_endian ? 'E' : 'G'
  end

  def rewind
    @cursor = 0
  end

  def position
    @cursor
  end

  def position=(val)
    @cursor = val
  end

  def clear
    @buf = []
    rewind
  end

  def size
    @buf.size
  end
  alias_method :length, :size

  def put(byte, offset=nil)
    @cursor = offset if offset
    @buf[@cursor] = byte
    @cursor += 1
  end

  def put_array(array, offset=nil)
    @cursor = offset if offset
    @buf[@cursor, array.length] = array
    @cursor += array.length
  end

  def put_int(i, offset=nil)
    a = []
    [i].pack(@int_pack_order).each_byte { |b| a << b }
    put_array(a, offset)
  end

  def put_long(i, offset=nil)
    offset = @cursor unless offset
    if @int_pack_order == 'N'
      put_int(i >> 32, offset)
      put_int(i & 0xffffffff, offset + 4)
    else
      put_int(i & 0xffffffff, offset)
      put_int(i >> 32, offset + 4)
    end
  end

  def put_double(d, offset=nil)
    a = []
    [d].pack(@double_pack_order).each_byte { |b| a << b }
    put_array(a, offset)
  end

  # If +size+ == nil, returns one byte. Else returns array of bytes of length
  # # +size+.
  def get(len=nil)
    one_byte = len.nil?
    len ||= 1
    check_read_length(len)
    start = @cursor
    @cursor += len
    if one_byte
      @buf[start]
    else
      if @buf.respond_to? "unpack"
        @buf[start, len].unpack("C*")
      else
        @buf[start, len]
      end
    end
  end

  def get_int
    check_read_length(4)
    vals = ""
    (@cursor..@cursor+3).each { |i| vals << @buf[i].chr }
    @cursor += 4
    vals.unpack(@int_pack_order)[0]
  end

  def get_long
    i1 = get_int
    i2 = get_int
    if @int_pack_order == 'N'
      (i1 << 32) + i2
    else
      (i2 << 32) + i1
    end
  end

  def get_double
    check_read_length(8)
    vals = ""
    (@cursor..@cursor+7).each { |i| vals << @buf[i].chr }
    @cursor += 8
    vals.unpack(@double_pack_order)[0]
  end

  def more?
    @cursor < @buf.size
  end

  def to_a
    if @buf.respond_to? "unpack"
      @buf.unpack("C*")
    else
      @buf
    end
  end

  def to_s
    if @buf.respond_to? "pack"
      @buf.pack("C*")
    else
      @buf
    end
  end

  def dump
    @buf.each_with_index { |c, i| $stderr.puts "#{'%04d' % i}: #{'%02x' % c} #{'%03o' % c} #{'%s' % c.chr} #{'%3d' % c}" }
  end

  private

  def check_read_length(len)
    raise "attempt to read past end of buffer" if @cursor + len > @buf.length
  end

end
