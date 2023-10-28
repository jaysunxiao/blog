#
# BSD 3-Clause License
#
# Copyright (c) 2018 - 2023, Oleg Malyavkin
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# DEBUG_TAB redefine this "  " if you need, example: const DEBUG_TAB = "\t"

const PROTO_VERSION = 3

const DEBUG_TAB : String = "  "

enum PB_ERR {
	NO_ERRORS = 0,
	VARINT_NOT_FOUND = -1,
	REPEATED_COUNT_NOT_FOUND = -2,
	REPEATED_COUNT_MISMATCH = -3,
	LENGTHDEL_SIZE_NOT_FOUND = -4,
	LENGTHDEL_SIZE_MISMATCH = -5,
	PACKAGE_SIZE_MISMATCH = -6,
	UNDEFINED_STATE = -7,
	PARSE_INCOMPLETE = -8,
	REQUIRED_FIELDS = -9
}

enum PB_DATA_TYPE {
	INT32 = 0,
	SINT32 = 1,
	UINT32 = 2,
	INT64 = 3,
	SINT64 = 4,
	UINT64 = 5,
	BOOL = 6,
	ENUM = 7,
	FIXED32 = 8,
	SFIXED32 = 9,
	FLOAT = 10,
	FIXED64 = 11,
	SFIXED64 = 12,
	DOUBLE = 13,
	STRING = 14,
	BYTES = 15,
	MESSAGE = 16,
	MAP = 17
}

const DEFAULT_VALUES_2 = {
	PB_DATA_TYPE.INT32: null,
	PB_DATA_TYPE.SINT32: null,
	PB_DATA_TYPE.UINT32: null,
	PB_DATA_TYPE.INT64: null,
	PB_DATA_TYPE.SINT64: null,
	PB_DATA_TYPE.UINT64: null,
	PB_DATA_TYPE.BOOL: null,
	PB_DATA_TYPE.ENUM: null,
	PB_DATA_TYPE.FIXED32: null,
	PB_DATA_TYPE.SFIXED32: null,
	PB_DATA_TYPE.FLOAT: null,
	PB_DATA_TYPE.FIXED64: null,
	PB_DATA_TYPE.SFIXED64: null,
	PB_DATA_TYPE.DOUBLE: null,
	PB_DATA_TYPE.STRING: null,
	PB_DATA_TYPE.BYTES: null,
	PB_DATA_TYPE.MESSAGE: null,
	PB_DATA_TYPE.MAP: null
}

const DEFAULT_VALUES_3 = {
	PB_DATA_TYPE.INT32: 0,
	PB_DATA_TYPE.SINT32: 0,
	PB_DATA_TYPE.UINT32: 0,
	PB_DATA_TYPE.INT64: 0,
	PB_DATA_TYPE.SINT64: 0,
	PB_DATA_TYPE.UINT64: 0,
	PB_DATA_TYPE.BOOL: false,
	PB_DATA_TYPE.ENUM: 0,
	PB_DATA_TYPE.FIXED32: 0,
	PB_DATA_TYPE.SFIXED32: 0,
	PB_DATA_TYPE.FLOAT: 0.0,
	PB_DATA_TYPE.FIXED64: 0,
	PB_DATA_TYPE.SFIXED64: 0,
	PB_DATA_TYPE.DOUBLE: 0.0,
	PB_DATA_TYPE.STRING: "",
	PB_DATA_TYPE.BYTES: [],
	PB_DATA_TYPE.MESSAGE: null,
	PB_DATA_TYPE.MAP: []
}

enum PB_TYPE {
	VARINT = 0,
	FIX64 = 1,
	LENGTHDEL = 2,
	STARTGROUP = 3,
	ENDGROUP = 4,
	FIX32 = 5,
	UNDEFINED = 8
}

enum PB_RULE {
	OPTIONAL = 0,
	REQUIRED = 1,
	REPEATED = 2,
	RESERVED = 3
}

enum PB_SERVICE_STATE {
	FILLED = 0,
	UNFILLED = 1
}

class PBField:
	func _init(a_name : String, a_type : int, a_rule : int, a_tag : int, packed : bool, a_value = null):
		name = a_name
		type = a_type
		rule = a_rule
		tag = a_tag
		option_packed = packed
		value = a_value
		
	var name : String
	var type : int
	var rule : int
	var tag : int
	var option_packed : bool
	var value
	var is_map_field : bool = false
	var option_default : bool = false

class PBTypeTag:
	var ok : bool = false
	var type : int
	var tag : int
	var offset : int

class PBServiceField:
	var field : PBField
	var func_ref = null
	var state : int = PB_SERVICE_STATE.UNFILLED

class PBPacker:
	static func convert_signed(n : int) -> int:
		if n < -2147483648:
			return (n << 1) ^ (n >> 63)
		else:
			return (n << 1) ^ (n >> 31)

	static func deconvert_signed(n : int) -> int:
		if n & 0x01:
			return ~(n >> 1)
		else:
			return (n >> 1)

	static func pack_varint(value) -> PackedByteArray:
		var varint : PackedByteArray = PackedByteArray()
		if typeof(value) == TYPE_BOOL:
			if value:
				value = 1
			else:
				value = 0
		for _i in range(9):
			var b = value & 0x7F
			value >>= 7
			if value:
				varint.append(b | 0x80)
			else:
				varint.append(b)
				break
		if varint.size() == 9 && varint[8] == 0xFF:
			varint.append(0x01)
		return varint

	static func pack_bytes(value, count : int, data_type : int) -> PackedByteArray:
		var bytes : PackedByteArray = PackedByteArray()
		if data_type == PB_DATA_TYPE.FLOAT:
			var spb : StreamPeerBuffer = StreamPeerBuffer.new()
			spb.put_float(value)
			bytes = spb.get_data_array()
		elif data_type == PB_DATA_TYPE.DOUBLE:
			var spb : StreamPeerBuffer = StreamPeerBuffer.new()
			spb.put_double(value)
			bytes = spb.get_data_array()
		else:
			for _i in range(count):
				bytes.append(value & 0xFF)
				value >>= 8
		return bytes

	static func unpack_bytes(bytes : PackedByteArray, index : int, count : int, data_type : int):
		var value = 0
		if data_type == PB_DATA_TYPE.FLOAT:
			var spb : StreamPeerBuffer = StreamPeerBuffer.new()
			for i in range(index, count + index):
				spb.put_u8(bytes[i])
			spb.seek(0)
			value = spb.get_float()
		elif data_type == PB_DATA_TYPE.DOUBLE:
			var spb : StreamPeerBuffer = StreamPeerBuffer.new()
			for i in range(index, count + index):
				spb.put_u8(bytes[i])
			spb.seek(0)
			value = spb.get_double()
		else:
			for i in range(index + count - 1, index - 1, -1):
				value |= (bytes[i] & 0xFF)
				if i != index:
					value <<= 8
		return value

	static func unpack_varint(varint_bytes) -> int:
		var value : int = 0
		for i in range(varint_bytes.size() - 1, -1, -1):
			value |= varint_bytes[i] & 0x7F
			if i != 0:
				value <<= 7
		return value

	static func pack_type_tag(type : int, tag : int) -> PackedByteArray:
		return pack_varint((tag << 3) | type)

	static func isolate_varint(bytes : PackedByteArray, index : int) -> PackedByteArray:
		var result : PackedByteArray = PackedByteArray()
		for i in range(index, bytes.size()):
			result.append(bytes[i])
			if !(bytes[i] & 0x80):
				break
		return result

	static func unpack_type_tag(bytes : PackedByteArray, index : int) -> PBTypeTag:
		var varint_bytes : PackedByteArray = isolate_varint(bytes, index)
		var result : PBTypeTag = PBTypeTag.new()
		if varint_bytes.size() != 0:
			result.ok = true
			result.offset = varint_bytes.size()
			var unpacked : int = unpack_varint(varint_bytes)
			result.type = unpacked & 0x07
			result.tag = unpacked >> 3
		return result

	static func pack_length_delimeted(type : int, tag : int, bytes : PackedByteArray) -> PackedByteArray:
		var result : PackedByteArray = pack_type_tag(type, tag)
		result.append_array(pack_varint(bytes.size()))
		result.append_array(bytes)
		return result

	static func pb_type_from_data_type(data_type : int) -> int:
		if data_type == PB_DATA_TYPE.INT32 || data_type == PB_DATA_TYPE.SINT32 || data_type == PB_DATA_TYPE.UINT32 || data_type == PB_DATA_TYPE.INT64 || data_type == PB_DATA_TYPE.SINT64 || data_type == PB_DATA_TYPE.UINT64 || data_type == PB_DATA_TYPE.BOOL || data_type == PB_DATA_TYPE.ENUM:
			return PB_TYPE.VARINT
		elif data_type == PB_DATA_TYPE.FIXED32 || data_type == PB_DATA_TYPE.SFIXED32 || data_type == PB_DATA_TYPE.FLOAT:
			return PB_TYPE.FIX32
		elif data_type == PB_DATA_TYPE.FIXED64 || data_type == PB_DATA_TYPE.SFIXED64 || data_type == PB_DATA_TYPE.DOUBLE:
			return PB_TYPE.FIX64
		elif data_type == PB_DATA_TYPE.STRING || data_type == PB_DATA_TYPE.BYTES || data_type == PB_DATA_TYPE.MESSAGE || data_type == PB_DATA_TYPE.MAP:
			return PB_TYPE.LENGTHDEL
		else:
			return PB_TYPE.UNDEFINED

	static func pack_field(field : PBField) -> PackedByteArray:
		var type : int = pb_type_from_data_type(field.type)
		var type_copy : int = type
		if field.rule == PB_RULE.REPEATED && field.option_packed:
			type = PB_TYPE.LENGTHDEL
		var head : PackedByteArray = pack_type_tag(type, field.tag)
		var data : PackedByteArray = PackedByteArray()
		if type == PB_TYPE.VARINT:
			var value
			if field.rule == PB_RULE.REPEATED:
				for v in field.value:
					data.append_array(head)
					if field.type == PB_DATA_TYPE.SINT32 || field.type == PB_DATA_TYPE.SINT64:
						value = convert_signed(v)
					else:
						value = v
					data.append_array(pack_varint(value))
				return data
			else:
				if field.type == PB_DATA_TYPE.SINT32 || field.type == PB_DATA_TYPE.SINT64:
					value = convert_signed(field.value)
				else:
					value = field.value
				data = pack_varint(value)
		elif type == PB_TYPE.FIX32:
			if field.rule == PB_RULE.REPEATED:
				for v in field.value:
					data.append_array(head)
					data.append_array(pack_bytes(v, 4, field.type))
				return data
			else:
				data.append_array(pack_bytes(field.value, 4, field.type))
		elif type == PB_TYPE.FIX64:
			if field.rule == PB_RULE.REPEATED:
				for v in field.value:
					data.append_array(head)
					data.append_array(pack_bytes(v, 8, field.type))
				return data
			else:
				data.append_array(pack_bytes(field.value, 8, field.type))
		elif type == PB_TYPE.LENGTHDEL:
			if field.rule == PB_RULE.REPEATED:
				if type_copy == PB_TYPE.VARINT:
					if field.type == PB_DATA_TYPE.SINT32 || field.type == PB_DATA_TYPE.SINT64:
						var signed_value : int
						for v in field.value:
							signed_value = convert_signed(v)
							data.append_array(pack_varint(signed_value))
					else:
						for v in field.value:
							data.append_array(pack_varint(v))
					return pack_length_delimeted(type, field.tag, data)
				elif type_copy == PB_TYPE.FIX32:
					for v in field.value:
						data.append_array(pack_bytes(v, 4, field.type))
					return pack_length_delimeted(type, field.tag, data)
				elif type_copy == PB_TYPE.FIX64:
					for v in field.value:
						data.append_array(pack_bytes(v, 8, field.type))
					return pack_length_delimeted(type, field.tag, data)
				elif field.type == PB_DATA_TYPE.STRING:
					for v in field.value:
						var obj = v.to_utf8_buffer()
						data.append_array(pack_length_delimeted(type, field.tag, obj))
					return data
				elif field.type == PB_DATA_TYPE.BYTES:
					for v in field.value:
						data.append_array(pack_length_delimeted(type, field.tag, v))
					return data
				elif typeof(field.value[0]) == TYPE_OBJECT:
					for v in field.value:
						var obj : PackedByteArray = v.to_bytes()
						data.append_array(pack_length_delimeted(type, field.tag, obj))
					return data
			else:
				if field.type == PB_DATA_TYPE.STRING:
					var str_bytes : PackedByteArray = field.value.to_utf8_buffer()
					if PROTO_VERSION == 2 || (PROTO_VERSION == 3 && str_bytes.size() > 0):
						data.append_array(str_bytes)
						return pack_length_delimeted(type, field.tag, data)
				if field.type == PB_DATA_TYPE.BYTES:
					if PROTO_VERSION == 2 || (PROTO_VERSION == 3 && field.value.size() > 0):
						data.append_array(field.value)
						return pack_length_delimeted(type, field.tag, data)
				elif typeof(field.value) == TYPE_OBJECT:
					var obj : PackedByteArray = field.value.to_bytes()
					if obj.size() > 0:
						data.append_array(obj)
					return pack_length_delimeted(type, field.tag, data)
				else:
					pass
		if data.size() > 0:
			head.append_array(data)
			return head
		else:
			return data

	static func unpack_field(bytes : PackedByteArray, offset : int, field : PBField, type : int, message_func_ref) -> int:
		if field.rule == PB_RULE.REPEATED && type != PB_TYPE.LENGTHDEL && field.option_packed:
			var count = isolate_varint(bytes, offset)
			if count.size() > 0:
				offset += count.size()
				count = unpack_varint(count)
				if type == PB_TYPE.VARINT:
					var val
					var counter = offset + count
					while offset < counter:
						val = isolate_varint(bytes, offset)
						if val.size() > 0:
							offset += val.size()
							val = unpack_varint(val)
							if field.type == PB_DATA_TYPE.SINT32 || field.type == PB_DATA_TYPE.SINT64:
								val = deconvert_signed(val)
							elif field.type == PB_DATA_TYPE.BOOL:
								if val:
									val = true
								else:
									val = false
							field.value.append(val)
						else:
							return PB_ERR.REPEATED_COUNT_MISMATCH
					return offset
				elif type == PB_TYPE.FIX32 || type == PB_TYPE.FIX64:
					var type_size
					if type == PB_TYPE.FIX32:
						type_size = 4
					else:
						type_size = 8
					var val
					var counter = offset + count
					while offset < counter:
						if (offset + type_size) > bytes.size():
							return PB_ERR.REPEATED_COUNT_MISMATCH
						val = unpack_bytes(bytes, offset, type_size, field.type)
						offset += type_size
						field.value.append(val)
					return offset
			else:
				return PB_ERR.REPEATED_COUNT_NOT_FOUND
		else:
			if type == PB_TYPE.VARINT:
				var val = isolate_varint(bytes, offset)
				if val.size() > 0:
					offset += val.size()
					val = unpack_varint(val)
					if field.type == PB_DATA_TYPE.SINT32 || field.type == PB_DATA_TYPE.SINT64:
						val = deconvert_signed(val)
					elif field.type == PB_DATA_TYPE.BOOL:
						if val:
							val = true
						else:
							val = false
					if field.rule == PB_RULE.REPEATED:
						field.value.append(val)
					else:
						field.value = val
				else:
					return PB_ERR.VARINT_NOT_FOUND
				return offset
			elif type == PB_TYPE.FIX32 || type == PB_TYPE.FIX64:
				var type_size
				if type == PB_TYPE.FIX32:
					type_size = 4
				else:
					type_size = 8
				var val
				if (offset + type_size) > bytes.size():
					return PB_ERR.REPEATED_COUNT_MISMATCH
				val = unpack_bytes(bytes, offset, type_size, field.type)
				offset += type_size
				if field.rule == PB_RULE.REPEATED:
					field.value.append(val)
				else:
					field.value = val
				return offset
			elif type == PB_TYPE.LENGTHDEL:
				var inner_size = isolate_varint(bytes, offset)
				if inner_size.size() > 0:
					offset += inner_size.size()
					inner_size = unpack_varint(inner_size)
					if inner_size >= 0:
						if inner_size + offset > bytes.size():
							return PB_ERR.LENGTHDEL_SIZE_MISMATCH
						if message_func_ref != null:
							var message = message_func_ref.call()
							if inner_size > 0:
								var sub_offset = message.from_bytes(bytes, offset, inner_size + offset)
								if sub_offset > 0:
									if sub_offset - offset >= inner_size:
										offset = sub_offset
										return offset
									else:
										return PB_ERR.LENGTHDEL_SIZE_MISMATCH
								return sub_offset
							else:
								return offset
						elif field.type == PB_DATA_TYPE.STRING:
							var str_bytes : PackedByteArray = PackedByteArray()
							for i in range(offset, inner_size + offset):
								str_bytes.append(bytes[i])
							if field.rule == PB_RULE.REPEATED:
								field.value.append(str_bytes.get_string_from_utf8())
							else:
								field.value = str_bytes.get_string_from_utf8()
							return offset + inner_size
						elif field.type == PB_DATA_TYPE.BYTES:
							var val_bytes : PackedByteArray = PackedByteArray()
							for i in range(offset, inner_size + offset):
								val_bytes.append(bytes[i])
							if field.rule == PB_RULE.REPEATED:
								field.value.append(val_bytes)
							else:
								field.value = val_bytes
							return offset + inner_size
					else:
						return PB_ERR.LENGTHDEL_SIZE_NOT_FOUND
				else:
					return PB_ERR.LENGTHDEL_SIZE_NOT_FOUND
		return PB_ERR.UNDEFINED_STATE

	static func unpack_message(data, bytes : PackedByteArray, offset : int, limit : int) -> int:
		while true:
			var tt : PBTypeTag = unpack_type_tag(bytes, offset)
			if tt.ok:
				offset += tt.offset
				if data.has(tt.tag):
					var service : PBServiceField = data[tt.tag]
					var type : int = pb_type_from_data_type(service.field.type)
					if type == tt.type || (tt.type == PB_TYPE.LENGTHDEL && service.field.rule == PB_RULE.REPEATED && service.field.option_packed):
						var res : int = unpack_field(bytes, offset, service.field, type, service.func_ref)
						if res > 0:
							service.state = PB_SERVICE_STATE.FILLED
							offset = res
							if offset == limit:
								return offset
							elif offset > limit:
								return PB_ERR.PACKAGE_SIZE_MISMATCH
						elif res < 0:
							return res
						else:
							break
			else:
				return offset
		return PB_ERR.UNDEFINED_STATE

	static func pack_message(data) -> PackedByteArray:
		var DEFAULT_VALUES
		if PROTO_VERSION == 2:
			DEFAULT_VALUES = DEFAULT_VALUES_2
		elif PROTO_VERSION == 3:
			DEFAULT_VALUES = DEFAULT_VALUES_3
		var result : PackedByteArray = PackedByteArray()
		var keys : Array = data.keys()
		keys.sort()
		for i in keys:
			if data[i].field.value != null:
				if data[i].state == PB_SERVICE_STATE.UNFILLED \
				&& !data[i].field.is_map_field \
				&& typeof(data[i].field.value) == typeof(DEFAULT_VALUES[data[i].field.type]) \
				&& data[i].field.value == DEFAULT_VALUES[data[i].field.type]:
					continue
				elif data[i].field.rule == PB_RULE.REPEATED && data[i].field.value.size() == 0:
					continue
				result.append_array(pack_field(data[i].field))
			elif data[i].field.rule == PB_RULE.REQUIRED:
				print("Error: required field is not filled: Tag:", data[i].field.tag)
				return PackedByteArray()
		return result

	static func check_required(data) -> bool:
		var keys : Array = data.keys()
		for i in keys:
			if data[i].field.rule == PB_RULE.REQUIRED && data[i].state == PB_SERVICE_STATE.UNFILLED:
				return false
		return true

	static func construct_map(key_values):
		var result = {}
		for kv in key_values:
			result[kv.get_key()] = kv.get_value()
		return result
	
	static func tabulate(text : String, nesting : int) -> String:
		var tab : String = ""
		for _i in range(nesting):
			tab += DEBUG_TAB
		return tab + text
	
	static func value_to_string(value, field : PBField, nesting : int) -> String:
		var result : String = ""
		var text : String
		if field.type == PB_DATA_TYPE.MESSAGE:
			result += "{"
			nesting += 1
			text = message_to_string(value.data, nesting)
			if text != "":
				result += "\n" + text
				nesting -= 1
				result += tabulate("}", nesting)
			else:
				nesting -= 1
				result += "}"
		elif field.type == PB_DATA_TYPE.BYTES:
			result += "<"
			for i in range(value.size()):
				result += str(value[i])
				if i != (value.size() - 1):
					result += ", "
			result += ">"
		elif field.type == PB_DATA_TYPE.STRING:
			result += "\"" + value + "\""
		elif field.type == PB_DATA_TYPE.ENUM:
			result += "ENUM::" + str(value)
		else:
			result += str(value)
		return result
	
	static func field_to_string(field : PBField, nesting : int) -> String:
		var result : String = tabulate(field.name + ": ", nesting)
		if field.type == PB_DATA_TYPE.MAP:
			if field.value.size() > 0:
				result += "(\n"
				nesting += 1
				for i in range(field.value.size()):
					var local_key_value = field.value[i].data[1].field
					result += tabulate(value_to_string(local_key_value.value, local_key_value, nesting), nesting) + ": "
					local_key_value = field.value[i].data[2].field
					result += value_to_string(local_key_value.value, local_key_value, nesting)
					if i != (field.value.size() - 1):
						result += ","
					result += "\n"
				nesting -= 1
				result += tabulate(")", nesting)
			else:
				result += "()"
		elif field.rule == PB_RULE.REPEATED:
			if field.value.size() > 0:
				result += "[\n"
				nesting += 1
				for i in range(field.value.size()):
					result += tabulate(str(i) + ": ", nesting)
					result += value_to_string(field.value[i], field, nesting)
					if i != (field.value.size() - 1):
						result += ","
					result += "\n"
				nesting -= 1
				result += tabulate("]", nesting)
			else:
				result += "[]"
		else:
			result += value_to_string(field.value, field, nesting)
		result += ";\n"
		return result
		
	static func message_to_string(data, nesting : int = 0) -> String:
		var DEFAULT_VALUES
		if PROTO_VERSION == 2:
			DEFAULT_VALUES = DEFAULT_VALUES_2
		elif PROTO_VERSION == 3:
			DEFAULT_VALUES = DEFAULT_VALUES_3
		var result : String = ""
		var keys : Array = data.keys()
		keys.sort()
		for i in keys:
			if data[i].field.value != null:
				if data[i].state == PB_SERVICE_STATE.UNFILLED \
				&& !data[i].field.is_map_field \
				&& typeof(data[i].field.value) == typeof(DEFAULT_VALUES[data[i].field.type]) \
				&& data[i].field.value == DEFAULT_VALUES[data[i].field.type]:
					continue
				elif data[i].field.rule == PB_RULE.REPEATED && data[i].field.value.size() == 0:
					continue
				result += field_to_string(data[i].field, nesting)
			elif data[i].field.rule == PB_RULE.REQUIRED:
				result += data[i].field.name + ": " + "error"
		return result



############### USER DATA BEGIN ################


class ObjectB:
	func _init():
		var service
		
		_flag = PBField.new("flag", PB_DATA_TYPE.BOOL, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.BOOL])
		service = PBServiceField.new()
		service.field = _flag
		data[_flag.tag] = service
		
	var data = {}
	
	var _flag: PBField
	func get_flag() -> bool:
		return _flag.value
	func clear_flag() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_flag.value = DEFAULT_VALUES_3[PB_DATA_TYPE.BOOL]
	func set_flag(value : bool) -> void:
		_flag.value = value
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class ObjectA:
	func _init():
		var service
		
		_a = PBField.new("a", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _a
		data[_a.tag] = service
		
		_m = PBField.new("m", PB_DATA_TYPE.MAP, PB_RULE.REPEATED, 2, true, [])
		service = PBServiceField.new()
		service.field = _m
		service.func_ref = Callable(self, "add_empty_m")
		data[_m.tag] = service
		
		_objectB = PBField.new("objectB", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 3, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _objectB
		service.func_ref = Callable(self, "new_objectB")
		data[_objectB.tag] = service
		
	var data = {}
	
	var _a: PBField
	func get_a() -> int:
		return _a.value
	func clear_a() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_a.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_a(value : int) -> void:
		_a.value = value
	
	var _m: PBField
	func get_raw_m():
		return _m.value
	func get_m():
		return PBPacker.construct_map(_m.value)
	func clear_m():
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_m.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MAP]
	func add_empty_m() -> ObjectA.map_type_m:
		var element = ObjectA.map_type_m.new()
		_m.value.append(element)
		return element
	func add_m(a_key, a_value) -> void:
		var idx = -1
		for i in range(_m.value.size()):
			if _m.value[i].get_key() == a_key:
				idx = i
				break
		var element = ObjectA.map_type_m.new()
		element.set_key(a_key)
		element.set_value(a_value)
		if idx != -1:
			_m.value[idx] = element
		else:
			_m.value.append(element)
	
	var _objectB: PBField
	func get_objectB() -> ObjectB:
		return _objectB.value
	func clear_objectB() -> void:
		data[3].state = PB_SERVICE_STATE.UNFILLED
		_objectB.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_objectB() -> ObjectB:
		_objectB.value = ObjectB.new()
		return _objectB.value
	
	class map_type_m:
		func _init():
			var service
			
			_key = PBField.new("key", PB_DATA_TYPE.INT32, PB_RULE.REQUIRED, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
			_key.is_map_field = true
			service = PBServiceField.new()
			service.field = _key
			data[_key.tag] = service
			
			_value = PBField.new("value", PB_DATA_TYPE.STRING, PB_RULE.REQUIRED, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
			_value.is_map_field = true
			service = PBServiceField.new()
			service.field = _value
			data[_value.tag] = service
			
		var data = {}
		
		var _key: PBField
		func get_key() -> int:
			return _key.value
		func clear_key() -> void:
			data[1].state = PB_SERVICE_STATE.UNFILLED
			_key.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
		func set_key(value : int) -> void:
			_key.value = value
		
		var _value: PBField
		func get_value() -> String:
			return _value.value
		func clear_value() -> void:
			data[2].state = PB_SERVICE_STATE.UNFILLED
			_value.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
		func set_value(value : String) -> void:
			_value.value = value
		
		func _to_string() -> String:
			return PBPacker.message_to_string(data)
			
		func to_bytes() -> PackedByteArray:
			return PBPacker.pack_message(data)
			
		func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
			var cur_limit = bytes.size()
			if limit != -1:
				cur_limit = limit
			var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
			if result == cur_limit:
				if PBPacker.check_required(data):
					if limit == -1:
						return PB_ERR.NO_ERRORS
				else:
					return PB_ERR.REQUIRED_FIELDS
			elif limit == -1 && result > 0:
				return PB_ERR.PARSE_INCOMPLETE
			return result
		
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class ListInteger:
	func _init():
		var service
		
		_a = PBField.new("a", PB_DATA_TYPE.INT32, PB_RULE.REPEATED, 1, true, [])
		service = PBServiceField.new()
		service.field = _a
		data[_a.tag] = service
		
	var data = {}
	
	var _a: PBField
	func get_a() -> Array:
		return _a.value
	func clear_a() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_a.value = []
	func add_a(value : int) -> void:
		_a.value.append(value)
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class ListListInteger:
	func _init():
		var service
		
		_a = PBField.new("a", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 1, true, [])
		service = PBServiceField.new()
		service.field = _a
		service.func_ref = Callable(self, "add_a")
		data[_a.tag] = service
		
	var data = {}
	
	var _a: PBField
	func get_a() -> Array:
		return _a.value
	func clear_a() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_a.value = []
	func add_a() -> ListInteger:
		var element = ListInteger.new()
		_a.value.append(element)
		return element
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class ListListListInteger:
	func _init():
		var service
		
		_a = PBField.new("a", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 1, true, [])
		service = PBServiceField.new()
		service.field = _a
		service.func_ref = Callable(self, "add_a")
		data[_a.tag] = service
		
	var data = {}
	
	var _a: PBField
	func get_a() -> Array:
		return _a.value
	func clear_a() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_a.value = []
	func add_a() -> ListListInteger:
		var element = ListListInteger.new()
		_a.value.append(element)
		return element
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class ListObjectA:
	func _init():
		var service
		
		_a = PBField.new("a", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 1, true, [])
		service = PBServiceField.new()
		service.field = _a
		service.func_ref = Callable(self, "add_a")
		data[_a.tag] = service
		
	var data = {}
	
	var _a: PBField
	func get_a() -> Array:
		return _a.value
	func clear_a() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_a.value = []
	func add_a() -> ObjectA:
		var element = ObjectA.new()
		_a.value.append(element)
		return element
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class ListListObjectA:
	func _init():
		var service
		
		_a = PBField.new("a", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 1, true, [])
		service = PBServiceField.new()
		service.field = _a
		service.func_ref = Callable(self, "add_a")
		data[_a.tag] = service
		
	var data = {}
	
	var _a: PBField
	func get_a() -> Array:
		return _a.value
	func clear_a() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_a.value = []
	func add_a() -> ListObjectA:
		var element = ListObjectA.new()
		_a.value.append(element)
		return element
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class MapObjectA:
	func _init():
		var service
		
		_key = PBField.new("key", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _key
		service.func_ref = Callable(self, "new_key")
		data[_key.tag] = service
		
		_value = PBField.new("value", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _value
		service.func_ref = Callable(self, "new_value")
		data[_value.tag] = service
		
	var data = {}
	
	var _key: PBField
	func get_key() -> ObjectA:
		return _key.value
	func clear_key() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_key.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_key() -> ObjectA:
		_key.value = ObjectA.new()
		return _key.value
	
	var _value: PBField
	func get_value() -> ListInteger:
		return _value.value
	func clear_value() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_value.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_value() -> ListInteger:
		_value.value = ListInteger.new()
		return _value.value
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class MapListListObjectA:
	func _init():
		var service
		
		_key = PBField.new("key", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _key
		service.func_ref = Callable(self, "new_key")
		data[_key.tag] = service
		
		_value = PBField.new("value", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _value
		service.func_ref = Callable(self, "new_value")
		data[_value.tag] = service
		
	var data = {}
	
	var _key: PBField
	func get_key() -> ListListObjectA:
		return _key.value
	func clear_key() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_key.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_key() -> ListListObjectA:
		_key.value = ListListObjectA.new()
		return _key.value
	
	var _value: PBField
	func get_value() -> ListListListInteger:
		return _value.value
	func clear_value() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_value.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_value() -> ListListListInteger:
		_value.value = ListListListInteger.new()
		return _value.value
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class MapIntegerString:
	func _init():
		var service
		
		_a = PBField.new("a", PB_DATA_TYPE.MAP, PB_RULE.REPEATED, 1, true, [])
		service = PBServiceField.new()
		service.field = _a
		service.func_ref = Callable(self, "add_empty_a")
		data[_a.tag] = service
		
	var data = {}
	
	var _a: PBField
	func get_raw_a():
		return _a.value
	func get_a():
		return PBPacker.construct_map(_a.value)
	func clear_a():
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_a.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MAP]
	func add_empty_a() -> MapIntegerString.map_type_a:
		var element = MapIntegerString.map_type_a.new()
		_a.value.append(element)
		return element
	func add_a(a_key, a_value) -> void:
		var idx = -1
		for i in range(_a.value.size()):
			if _a.value[i].get_key() == a_key:
				idx = i
				break
		var element = MapIntegerString.map_type_a.new()
		element.set_key(a_key)
		element.set_value(a_value)
		if idx != -1:
			_a.value[idx] = element
		else:
			_a.value.append(element)
	
	class map_type_a:
		func _init():
			var service
			
			_key = PBField.new("key", PB_DATA_TYPE.INT32, PB_RULE.REQUIRED, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
			_key.is_map_field = true
			service = PBServiceField.new()
			service.field = _key
			data[_key.tag] = service
			
			_value = PBField.new("value", PB_DATA_TYPE.STRING, PB_RULE.REQUIRED, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
			_value.is_map_field = true
			service = PBServiceField.new()
			service.field = _value
			data[_value.tag] = service
			
		var data = {}
		
		var _key: PBField
		func get_key() -> int:
			return _key.value
		func clear_key() -> void:
			data[1].state = PB_SERVICE_STATE.UNFILLED
			_key.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
		func set_key(value : int) -> void:
			_key.value = value
		
		var _value: PBField
		func get_value() -> String:
			return _value.value
		func clear_value() -> void:
			data[2].state = PB_SERVICE_STATE.UNFILLED
			_value.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
		func set_value(value : String) -> void:
			_value.value = value
		
		func _to_string() -> String:
			return PBPacker.message_to_string(data)
			
		func to_bytes() -> PackedByteArray:
			return PBPacker.pack_message(data)
			
		func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
			var cur_limit = bytes.size()
			if limit != -1:
				cur_limit = limit
			var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
			if result == cur_limit:
				if PBPacker.check_required(data):
					if limit == -1:
						return PB_ERR.NO_ERRORS
				else:
					return PB_ERR.REQUIRED_FIELDS
			elif limit == -1 && result > 0:
				return PB_ERR.PARSE_INCOMPLETE
			return result
		
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class ListMapIntegerString:
	func _init():
		var service
		
		_a = PBField.new("a", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 1, true, [])
		service = PBServiceField.new()
		service.field = _a
		service.func_ref = Callable(self, "add_a")
		data[_a.tag] = service
		
	var data = {}
	
	var _a: PBField
	func get_a() -> Array:
		return _a.value
	func clear_a() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_a.value = []
	func add_a() -> MapIntegerString:
		var element = MapIntegerString.new()
		_a.value.append(element)
		return element
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class MapListMapInteger:
	func _init():
		var service
		
		_key = PBField.new("key", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _key
		service.func_ref = Callable(self, "new_key")
		data[_key.tag] = service
		
		_value = PBField.new("value", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _value
		service.func_ref = Callable(self, "new_value")
		data[_value.tag] = service
		
	var data = {}
	
	var _key: PBField
	func get_key() -> ListMapIntegerString:
		return _key.value
	func clear_key() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_key.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_key() -> ListMapIntegerString:
		_key.value = ListMapIntegerString.new()
		return _key.value
	
	var _value: PBField
	func get_value() -> ListMapIntegerString:
		return _value.value
	func clear_value() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_value.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_value() -> ListMapIntegerString:
		_value.value = ListMapIntegerString.new()
		return _value.value
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class ProtobufComplexObject:
	func _init():
		var service
		
		_a = PBField.new("a", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _a
		data[_a.tag] = service
		
		_aa = PBField.new("aa", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _aa
		data[_aa.tag] = service
		
		_aaa = PBField.new("aaa", PB_DATA_TYPE.BYTES, PB_RULE.OPTIONAL, 3, true, DEFAULT_VALUES_3[PB_DATA_TYPE.BYTES])
		service = PBServiceField.new()
		service.field = _aaa
		data[_aaa.tag] = service
		
		_aaaa = PBField.new("aaaa", PB_DATA_TYPE.BYTES, PB_RULE.OPTIONAL, 4, true, DEFAULT_VALUES_3[PB_DATA_TYPE.BYTES])
		service = PBServiceField.new()
		service.field = _aaaa
		data[_aaaa.tag] = service
		
		_b = PBField.new("b", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 5, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _b
		data[_b.tag] = service
		
		_bb = PBField.new("bb", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 6, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _bb
		data[_bb.tag] = service
		
		_bbb = PBField.new("bbb", PB_DATA_TYPE.BYTES, PB_RULE.OPTIONAL, 7, true, DEFAULT_VALUES_3[PB_DATA_TYPE.BYTES])
		service = PBServiceField.new()
		service.field = _bbb
		data[_bbb.tag] = service
		
		_bbbb = PBField.new("bbbb", PB_DATA_TYPE.BYTES, PB_RULE.OPTIONAL, 8, true, DEFAULT_VALUES_3[PB_DATA_TYPE.BYTES])
		service = PBServiceField.new()
		service.field = _bbbb
		data[_bbbb.tag] = service
		
		_c = PBField.new("c", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 9, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _c
		data[_c.tag] = service
		
		_cc = PBField.new("cc", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 10, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _cc
		data[_cc.tag] = service
		
		_ccc = PBField.new("ccc", PB_DATA_TYPE.INT32, PB_RULE.REPEATED, 11, true, [])
		service = PBServiceField.new()
		service.field = _ccc
		data[_ccc.tag] = service
		
		_cccc = PBField.new("cccc", PB_DATA_TYPE.INT32, PB_RULE.REPEATED, 12, true, [])
		service = PBServiceField.new()
		service.field = _cccc
		data[_cccc.tag] = service
		
		_d = PBField.new("d", PB_DATA_TYPE.INT64, PB_RULE.OPTIONAL, 13, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT64])
		service = PBServiceField.new()
		service.field = _d
		data[_d.tag] = service
		
		_dd = PBField.new("dd", PB_DATA_TYPE.INT64, PB_RULE.OPTIONAL, 14, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT64])
		service = PBServiceField.new()
		service.field = _dd
		data[_dd.tag] = service
		
		_ddd = PBField.new("ddd", PB_DATA_TYPE.INT64, PB_RULE.REPEATED, 15, true, [])
		service = PBServiceField.new()
		service.field = _ddd
		data[_ddd.tag] = service
		
		_dddd = PBField.new("dddd", PB_DATA_TYPE.INT64, PB_RULE.REPEATED, 16, true, [])
		service = PBServiceField.new()
		service.field = _dddd
		data[_dddd.tag] = service
		
		_e = PBField.new("e", PB_DATA_TYPE.FLOAT, PB_RULE.OPTIONAL, 17, true, DEFAULT_VALUES_3[PB_DATA_TYPE.FLOAT])
		service = PBServiceField.new()
		service.field = _e
		data[_e.tag] = service
		
		_ee = PBField.new("ee", PB_DATA_TYPE.FLOAT, PB_RULE.OPTIONAL, 18, true, DEFAULT_VALUES_3[PB_DATA_TYPE.FLOAT])
		service = PBServiceField.new()
		service.field = _ee
		data[_ee.tag] = service
		
		_eee = PBField.new("eee", PB_DATA_TYPE.FLOAT, PB_RULE.REPEATED, 19, true, [])
		service = PBServiceField.new()
		service.field = _eee
		data[_eee.tag] = service
		
		_eeee = PBField.new("eeee", PB_DATA_TYPE.FLOAT, PB_RULE.REPEATED, 20, true, [])
		service = PBServiceField.new()
		service.field = _eeee
		data[_eeee.tag] = service
		
		_f = PBField.new("f", PB_DATA_TYPE.DOUBLE, PB_RULE.OPTIONAL, 21, true, DEFAULT_VALUES_3[PB_DATA_TYPE.DOUBLE])
		service = PBServiceField.new()
		service.field = _f
		data[_f.tag] = service
		
		_ff = PBField.new("ff", PB_DATA_TYPE.DOUBLE, PB_RULE.OPTIONAL, 22, true, DEFAULT_VALUES_3[PB_DATA_TYPE.DOUBLE])
		service = PBServiceField.new()
		service.field = _ff
		data[_ff.tag] = service
		
		_fff = PBField.new("fff", PB_DATA_TYPE.DOUBLE, PB_RULE.REPEATED, 23, true, [])
		service = PBServiceField.new()
		service.field = _fff
		data[_fff.tag] = service
		
		_ffff = PBField.new("ffff", PB_DATA_TYPE.DOUBLE, PB_RULE.REPEATED, 24, true, [])
		service = PBServiceField.new()
		service.field = _ffff
		data[_ffff.tag] = service
		
		_g = PBField.new("g", PB_DATA_TYPE.BOOL, PB_RULE.OPTIONAL, 25, true, DEFAULT_VALUES_3[PB_DATA_TYPE.BOOL])
		service = PBServiceField.new()
		service.field = _g
		data[_g.tag] = service
		
		_gg = PBField.new("gg", PB_DATA_TYPE.BOOL, PB_RULE.OPTIONAL, 26, true, DEFAULT_VALUES_3[PB_DATA_TYPE.BOOL])
		service = PBServiceField.new()
		service.field = _gg
		data[_gg.tag] = service
		
		_ggg = PBField.new("ggg", PB_DATA_TYPE.BOOL, PB_RULE.REPEATED, 27, true, [])
		service = PBServiceField.new()
		service.field = _ggg
		data[_ggg.tag] = service
		
		_gggg = PBField.new("gggg", PB_DATA_TYPE.BOOL, PB_RULE.REPEATED, 28, true, [])
		service = PBServiceField.new()
		service.field = _gggg
		data[_gggg.tag] = service
		
		_h = PBField.new("h", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 29, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _h
		data[_h.tag] = service
		
		_hh = PBField.new("hh", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 30, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _hh
		data[_hh.tag] = service
		
		_hhh = PBField.new("hhh", PB_DATA_TYPE.STRING, PB_RULE.REPEATED, 31, true, [])
		service = PBServiceField.new()
		service.field = _hhh
		data[_hhh.tag] = service
		
		_hhhh = PBField.new("hhhh", PB_DATA_TYPE.STRING, PB_RULE.REPEATED, 32, true, [])
		service = PBServiceField.new()
		service.field = _hhhh
		data[_hhhh.tag] = service
		
		_jj = PBField.new("jj", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 33, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _jj
		data[_jj.tag] = service
		
		_jjj = PBField.new("jjj", PB_DATA_TYPE.STRING, PB_RULE.REPEATED, 34, true, [])
		service = PBServiceField.new()
		service.field = _jjj
		data[_jjj.tag] = service
		
		_kk = PBField.new("kk", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 35, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _kk
		service.func_ref = Callable(self, "new_kk")
		data[_kk.tag] = service
		
		_kkk = PBField.new("kkk", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 36, true, [])
		service = PBServiceField.new()
		service.field = _kkk
		service.func_ref = Callable(self, "add_kkk")
		data[_kkk.tag] = service
		
		_l = PBField.new("l", PB_DATA_TYPE.INT32, PB_RULE.REPEATED, 37, true, [])
		service = PBServiceField.new()
		service.field = _l
		data[_l.tag] = service
		
		_ll = PBField.new("ll", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 38, true, [])
		service = PBServiceField.new()
		service.field = _ll
		service.func_ref = Callable(self, "add_ll")
		data[_ll.tag] = service
		
		_lll = PBField.new("lll", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 39, true, [])
		service = PBServiceField.new()
		service.field = _lll
		service.func_ref = Callable(self, "add_lll")
		data[_lll.tag] = service
		
		_llll = PBField.new("llll", PB_DATA_TYPE.STRING, PB_RULE.REPEATED, 40, true, [])
		service = PBServiceField.new()
		service.field = _llll
		data[_llll.tag] = service
		
		_lllll = PBField.new("lllll", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 41, true, [])
		service = PBServiceField.new()
		service.field = _lllll
		service.func_ref = Callable(self, "add_lllll")
		data[_lllll.tag] = service
		
		_m = PBField.new("m", PB_DATA_TYPE.MAP, PB_RULE.REPEATED, 51, true, [])
		service = PBServiceField.new()
		service.field = _m
		service.func_ref = Callable(self, "add_empty_m")
		data[_m.tag] = service
		
		_mm = PBField.new("mm", PB_DATA_TYPE.MAP, PB_RULE.REPEATED, 52, true, [])
		service = PBServiceField.new()
		service.field = _mm
		service.func_ref = Callable(self, "add_empty_mm")
		data[_mm.tag] = service
		
		_mmm = PBField.new("mmm", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 53, true, [])
		service = PBServiceField.new()
		service.field = _mmm
		service.func_ref = Callable(self, "add_mmm")
		data[_mmm.tag] = service
		
		_mmmm = PBField.new("mmmm", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 54, true, [])
		service = PBServiceField.new()
		service.field = _mmmm
		service.func_ref = Callable(self, "add_mmmm")
		data[_mmmm.tag] = service
		
		_mmmmm = PBField.new("mmmmm", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 55, true, [])
		service = PBServiceField.new()
		service.field = _mmmmm
		service.func_ref = Callable(self, "add_mmmmm")
		data[_mmmmm.tag] = service
		
		_s = PBField.new("s", PB_DATA_TYPE.INT32, PB_RULE.REPEATED, 61, true, [])
		service = PBServiceField.new()
		service.field = _s
		data[_s.tag] = service
		
		_ss = PBField.new("ss", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 62, true, [])
		service = PBServiceField.new()
		service.field = _ss
		service.func_ref = Callable(self, "add_ss")
		data[_ss.tag] = service
		
		_sss = PBField.new("sss", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 63, true, [])
		service = PBServiceField.new()
		service.field = _sss
		service.func_ref = Callable(self, "add_sss")
		data[_sss.tag] = service
		
		_ssss = PBField.new("ssss", PB_DATA_TYPE.STRING, PB_RULE.REPEATED, 64, true, [])
		service = PBServiceField.new()
		service.field = _ssss
		data[_ssss.tag] = service
		
		_sssss = PBField.new("sssss", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 65, true, [])
		service = PBServiceField.new()
		service.field = _sssss
		service.func_ref = Callable(self, "add_sssss")
		data[_sssss.tag] = service
		
	var data = {}
	
	var _a: PBField
	func get_a() -> int:
		return _a.value
	func clear_a() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_a.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_a(value : int) -> void:
		_a.value = value
	
	var _aa: PBField
	func get_aa() -> int:
		return _aa.value
	func clear_aa() -> void:
		data[2].state = PB_SERVICE_STATE.UNFILLED
		_aa.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_aa(value : int) -> void:
		_aa.value = value
	
	var _aaa: PBField
	func get_aaa() -> PackedByteArray:
		return _aaa.value
	func clear_aaa() -> void:
		data[3].state = PB_SERVICE_STATE.UNFILLED
		_aaa.value = DEFAULT_VALUES_3[PB_DATA_TYPE.BYTES]
	func set_aaa(value : PackedByteArray) -> void:
		_aaa.value = value
	
	var _aaaa: PBField
	func get_aaaa() -> PackedByteArray:
		return _aaaa.value
	func clear_aaaa() -> void:
		data[4].state = PB_SERVICE_STATE.UNFILLED
		_aaaa.value = DEFAULT_VALUES_3[PB_DATA_TYPE.BYTES]
	func set_aaaa(value : PackedByteArray) -> void:
		_aaaa.value = value
	
	var _b: PBField
	func get_b() -> int:
		return _b.value
	func clear_b() -> void:
		data[5].state = PB_SERVICE_STATE.UNFILLED
		_b.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_b(value : int) -> void:
		_b.value = value
	
	var _bb: PBField
	func get_bb() -> int:
		return _bb.value
	func clear_bb() -> void:
		data[6].state = PB_SERVICE_STATE.UNFILLED
		_bb.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_bb(value : int) -> void:
		_bb.value = value
	
	var _bbb: PBField
	func get_bbb() -> PackedByteArray:
		return _bbb.value
	func clear_bbb() -> void:
		data[7].state = PB_SERVICE_STATE.UNFILLED
		_bbb.value = DEFAULT_VALUES_3[PB_DATA_TYPE.BYTES]
	func set_bbb(value : PackedByteArray) -> void:
		_bbb.value = value
	
	var _bbbb: PBField
	func get_bbbb() -> PackedByteArray:
		return _bbbb.value
	func clear_bbbb() -> void:
		data[8].state = PB_SERVICE_STATE.UNFILLED
		_bbbb.value = DEFAULT_VALUES_3[PB_DATA_TYPE.BYTES]
	func set_bbbb(value : PackedByteArray) -> void:
		_bbbb.value = value
	
	var _c: PBField
	func get_c() -> int:
		return _c.value
	func clear_c() -> void:
		data[9].state = PB_SERVICE_STATE.UNFILLED
		_c.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_c(value : int) -> void:
		_c.value = value
	
	var _cc: PBField
	func get_cc() -> int:
		return _cc.value
	func clear_cc() -> void:
		data[10].state = PB_SERVICE_STATE.UNFILLED
		_cc.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_cc(value : int) -> void:
		_cc.value = value
	
	var _ccc: PBField
	func get_ccc() -> Array:
		return _ccc.value
	func clear_ccc() -> void:
		data[11].state = PB_SERVICE_STATE.UNFILLED
		_ccc.value = []
	func add_ccc(value : int) -> void:
		_ccc.value.append(value)
	
	var _cccc: PBField
	func get_cccc() -> Array:
		return _cccc.value
	func clear_cccc() -> void:
		data[12].state = PB_SERVICE_STATE.UNFILLED
		_cccc.value = []
	func add_cccc(value : int) -> void:
		_cccc.value.append(value)
	
	var _d: PBField
	func get_d() -> int:
		return _d.value
	func clear_d() -> void:
		data[13].state = PB_SERVICE_STATE.UNFILLED
		_d.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT64]
	func set_d(value : int) -> void:
		_d.value = value
	
	var _dd: PBField
	func get_dd() -> int:
		return _dd.value
	func clear_dd() -> void:
		data[14].state = PB_SERVICE_STATE.UNFILLED
		_dd.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT64]
	func set_dd(value : int) -> void:
		_dd.value = value
	
	var _ddd: PBField
	func get_ddd() -> Array:
		return _ddd.value
	func clear_ddd() -> void:
		data[15].state = PB_SERVICE_STATE.UNFILLED
		_ddd.value = []
	func add_ddd(value : int) -> void:
		_ddd.value.append(value)
	
	var _dddd: PBField
	func get_dddd() -> Array:
		return _dddd.value
	func clear_dddd() -> void:
		data[16].state = PB_SERVICE_STATE.UNFILLED
		_dddd.value = []
	func add_dddd(value : int) -> void:
		_dddd.value.append(value)
	
	var _e: PBField
	func get_e() -> float:
		return _e.value
	func clear_e() -> void:
		data[17].state = PB_SERVICE_STATE.UNFILLED
		_e.value = DEFAULT_VALUES_3[PB_DATA_TYPE.FLOAT]
	func set_e(value : float) -> void:
		_e.value = value
	
	var _ee: PBField
	func get_ee() -> float:
		return _ee.value
	func clear_ee() -> void:
		data[18].state = PB_SERVICE_STATE.UNFILLED
		_ee.value = DEFAULT_VALUES_3[PB_DATA_TYPE.FLOAT]
	func set_ee(value : float) -> void:
		_ee.value = value
	
	var _eee: PBField
	func get_eee() -> Array:
		return _eee.value
	func clear_eee() -> void:
		data[19].state = PB_SERVICE_STATE.UNFILLED
		_eee.value = []
	func add_eee(value : float) -> void:
		_eee.value.append(value)
	
	var _eeee: PBField
	func get_eeee() -> Array:
		return _eeee.value
	func clear_eeee() -> void:
		data[20].state = PB_SERVICE_STATE.UNFILLED
		_eeee.value = []
	func add_eeee(value : float) -> void:
		_eeee.value.append(value)
	
	var _f: PBField
	func get_f() -> float:
		return _f.value
	func clear_f() -> void:
		data[21].state = PB_SERVICE_STATE.UNFILLED
		_f.value = DEFAULT_VALUES_3[PB_DATA_TYPE.DOUBLE]
	func set_f(value : float) -> void:
		_f.value = value
	
	var _ff: PBField
	func get_ff() -> float:
		return _ff.value
	func clear_ff() -> void:
		data[22].state = PB_SERVICE_STATE.UNFILLED
		_ff.value = DEFAULT_VALUES_3[PB_DATA_TYPE.DOUBLE]
	func set_ff(value : float) -> void:
		_ff.value = value
	
	var _fff: PBField
	func get_fff() -> Array:
		return _fff.value
	func clear_fff() -> void:
		data[23].state = PB_SERVICE_STATE.UNFILLED
		_fff.value = []
	func add_fff(value : float) -> void:
		_fff.value.append(value)
	
	var _ffff: PBField
	func get_ffff() -> Array:
		return _ffff.value
	func clear_ffff() -> void:
		data[24].state = PB_SERVICE_STATE.UNFILLED
		_ffff.value = []
	func add_ffff(value : float) -> void:
		_ffff.value.append(value)
	
	var _g: PBField
	func get_g() -> bool:
		return _g.value
	func clear_g() -> void:
		data[25].state = PB_SERVICE_STATE.UNFILLED
		_g.value = DEFAULT_VALUES_3[PB_DATA_TYPE.BOOL]
	func set_g(value : bool) -> void:
		_g.value = value
	
	var _gg: PBField
	func get_gg() -> bool:
		return _gg.value
	func clear_gg() -> void:
		data[26].state = PB_SERVICE_STATE.UNFILLED
		_gg.value = DEFAULT_VALUES_3[PB_DATA_TYPE.BOOL]
	func set_gg(value : bool) -> void:
		_gg.value = value
	
	var _ggg: PBField
	func get_ggg() -> Array:
		return _ggg.value
	func clear_ggg() -> void:
		data[27].state = PB_SERVICE_STATE.UNFILLED
		_ggg.value = []
	func add_ggg(value : bool) -> void:
		_ggg.value.append(value)
	
	var _gggg: PBField
	func get_gggg() -> Array:
		return _gggg.value
	func clear_gggg() -> void:
		data[28].state = PB_SERVICE_STATE.UNFILLED
		_gggg.value = []
	func add_gggg(value : bool) -> void:
		_gggg.value.append(value)
	
	var _h: PBField
	func get_h() -> String:
		return _h.value
	func clear_h() -> void:
		data[29].state = PB_SERVICE_STATE.UNFILLED
		_h.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_h(value : String) -> void:
		_h.value = value
	
	var _hh: PBField
	func get_hh() -> String:
		return _hh.value
	func clear_hh() -> void:
		data[30].state = PB_SERVICE_STATE.UNFILLED
		_hh.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_hh(value : String) -> void:
		_hh.value = value
	
	var _hhh: PBField
	func get_hhh() -> Array:
		return _hhh.value
	func clear_hhh() -> void:
		data[31].state = PB_SERVICE_STATE.UNFILLED
		_hhh.value = []
	func add_hhh(value : String) -> void:
		_hhh.value.append(value)
	
	var _hhhh: PBField
	func get_hhhh() -> Array:
		return _hhhh.value
	func clear_hhhh() -> void:
		data[32].state = PB_SERVICE_STATE.UNFILLED
		_hhhh.value = []
	func add_hhhh(value : String) -> void:
		_hhhh.value.append(value)
	
	var _jj: PBField
	func get_jj() -> String:
		return _jj.value
	func clear_jj() -> void:
		data[33].state = PB_SERVICE_STATE.UNFILLED
		_jj.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_jj(value : String) -> void:
		_jj.value = value
	
	var _jjj: PBField
	func get_jjj() -> Array:
		return _jjj.value
	func clear_jjj() -> void:
		data[34].state = PB_SERVICE_STATE.UNFILLED
		_jjj.value = []
	func add_jjj(value : String) -> void:
		_jjj.value.append(value)
	
	var _kk: PBField
	func get_kk() -> ObjectA:
		return _kk.value
	func clear_kk() -> void:
		data[35].state = PB_SERVICE_STATE.UNFILLED
		_kk.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_kk() -> ObjectA:
		_kk.value = ObjectA.new()
		return _kk.value
	
	var _kkk: PBField
	func get_kkk() -> Array:
		return _kkk.value
	func clear_kkk() -> void:
		data[36].state = PB_SERVICE_STATE.UNFILLED
		_kkk.value = []
	func add_kkk() -> ObjectA:
		var element = ObjectA.new()
		_kkk.value.append(element)
		return element
	
	var _l: PBField
	func get_l() -> Array:
		return _l.value
	func clear_l() -> void:
		data[37].state = PB_SERVICE_STATE.UNFILLED
		_l.value = []
	func add_l(value : int) -> void:
		_l.value.append(value)
	
	var _ll: PBField
	func get_ll() -> Array:
		return _ll.value
	func clear_ll() -> void:
		data[38].state = PB_SERVICE_STATE.UNFILLED
		_ll.value = []
	func add_ll() -> ListListInteger:
		var element = ListListInteger.new()
		_ll.value.append(element)
		return element
	
	var _lll: PBField
	func get_lll() -> Array:
		return _lll.value
	func clear_lll() -> void:
		data[39].state = PB_SERVICE_STATE.UNFILLED
		_lll.value = []
	func add_lll() -> ListObjectA:
		var element = ListObjectA.new()
		_lll.value.append(element)
		return element
	
	var _llll: PBField
	func get_llll() -> Array:
		return _llll.value
	func clear_llll() -> void:
		data[40].state = PB_SERVICE_STATE.UNFILLED
		_llll.value = []
	func add_llll(value : String) -> void:
		_llll.value.append(value)
	
	var _lllll: PBField
	func get_lllll() -> Array:
		return _lllll.value
	func clear_lllll() -> void:
		data[41].state = PB_SERVICE_STATE.UNFILLED
		_lllll.value = []
	func add_lllll() -> MapIntegerString:
		var element = MapIntegerString.new()
		_lllll.value.append(element)
		return element
	
	var _m: PBField
	func get_raw_m():
		return _m.value
	func get_m():
		return PBPacker.construct_map(_m.value)
	func clear_m():
		data[51].state = PB_SERVICE_STATE.UNFILLED
		_m.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MAP]
	func add_empty_m() -> ProtobufComplexObject.map_type_m:
		var element = ProtobufComplexObject.map_type_m.new()
		_m.value.append(element)
		return element
	func add_m(a_key, a_value) -> void:
		var idx = -1
		for i in range(_m.value.size()):
			if _m.value[i].get_key() == a_key:
				idx = i
				break
		var element = ProtobufComplexObject.map_type_m.new()
		element.set_key(a_key)
		element.set_value(a_value)
		if idx != -1:
			_m.value[idx] = element
		else:
			_m.value.append(element)
	
	var _mm: PBField
	func get_raw_mm():
		return _mm.value
	func get_mm():
		return PBPacker.construct_map(_mm.value)
	func clear_mm():
		data[52].state = PB_SERVICE_STATE.UNFILLED
		_mm.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MAP]
	func add_empty_mm() -> ProtobufComplexObject.map_type_mm:
		var element = ProtobufComplexObject.map_type_mm.new()
		_mm.value.append(element)
		return element
	func add_mm(a_key) -> ProtobufComplexObject.ObjectA:
		var idx = -1
		for i in range(_mm.value.size()):
			if _mm.value[i].get_key() == a_key:
				idx = i
				break
		var element = ProtobufComplexObject.map_type_mm.new()
		element.set_key(a_key)
		if idx != -1:
			_mm.value[idx] = element
		else:
			_mm.value.append(element)
		return element.new_value()
	
	var _mmm: PBField
	func get_mmm() -> Array:
		return _mmm.value
	func clear_mmm() -> void:
		data[53].state = PB_SERVICE_STATE.UNFILLED
		_mmm.value = []
	func add_mmm() -> MapObjectA:
		var element = MapObjectA.new()
		_mmm.value.append(element)
		return element
	
	var _mmmm: PBField
	func get_mmmm() -> Array:
		return _mmmm.value
	func clear_mmmm() -> void:
		data[54].state = PB_SERVICE_STATE.UNFILLED
		_mmmm.value = []
	func add_mmmm() -> MapListListObjectA:
		var element = MapListListObjectA.new()
		_mmmm.value.append(element)
		return element
	
	var _mmmmm: PBField
	func get_mmmmm() -> Array:
		return _mmmmm.value
	func clear_mmmmm() -> void:
		data[55].state = PB_SERVICE_STATE.UNFILLED
		_mmmmm.value = []
	func add_mmmmm() -> MapListMapInteger:
		var element = MapListMapInteger.new()
		_mmmmm.value.append(element)
		return element
	
	var _s: PBField
	func get_s() -> Array:
		return _s.value
	func clear_s() -> void:
		data[61].state = PB_SERVICE_STATE.UNFILLED
		_s.value = []
	func add_s(value : int) -> void:
		_s.value.append(value)
	
	var _ss: PBField
	func get_ss() -> Array:
		return _ss.value
	func clear_ss() -> void:
		data[62].state = PB_SERVICE_STATE.UNFILLED
		_ss.value = []
	func add_ss() -> ListListInteger:
		var element = ListListInteger.new()
		_ss.value.append(element)
		return element
	
	var _sss: PBField
	func get_sss() -> Array:
		return _sss.value
	func clear_sss() -> void:
		data[63].state = PB_SERVICE_STATE.UNFILLED
		_sss.value = []
	func add_sss() -> ListObjectA:
		var element = ListObjectA.new()
		_sss.value.append(element)
		return element
	
	var _ssss: PBField
	func get_ssss() -> Array:
		return _ssss.value
	func clear_ssss() -> void:
		data[64].state = PB_SERVICE_STATE.UNFILLED
		_ssss.value = []
	func add_ssss(value : String) -> void:
		_ssss.value.append(value)
	
	var _sssss: PBField
	func get_sssss() -> Array:
		return _sssss.value
	func clear_sssss() -> void:
		data[65].state = PB_SERVICE_STATE.UNFILLED
		_sssss.value = []
	func add_sssss() -> MapIntegerString:
		var element = MapIntegerString.new()
		_sssss.value.append(element)
		return element
	
	class map_type_m:
		func _init():
			var service
			
			_key = PBField.new("key", PB_DATA_TYPE.INT32, PB_RULE.REQUIRED, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
			_key.is_map_field = true
			service = PBServiceField.new()
			service.field = _key
			data[_key.tag] = service
			
			_value = PBField.new("value", PB_DATA_TYPE.STRING, PB_RULE.REQUIRED, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
			_value.is_map_field = true
			service = PBServiceField.new()
			service.field = _value
			data[_value.tag] = service
			
		var data = {}
		
		var _key: PBField
		func get_key() -> int:
			return _key.value
		func clear_key() -> void:
			data[1].state = PB_SERVICE_STATE.UNFILLED
			_key.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
		func set_key(value : int) -> void:
			_key.value = value
		
		var _value: PBField
		func get_value() -> String:
			return _value.value
		func clear_value() -> void:
			data[2].state = PB_SERVICE_STATE.UNFILLED
			_value.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
		func set_value(value : String) -> void:
			_value.value = value
		
		func _to_string() -> String:
			return PBPacker.message_to_string(data)
			
		func to_bytes() -> PackedByteArray:
			return PBPacker.pack_message(data)
			
		func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
			var cur_limit = bytes.size()
			if limit != -1:
				cur_limit = limit
			var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
			if result == cur_limit:
				if PBPacker.check_required(data):
					if limit == -1:
						return PB_ERR.NO_ERRORS
				else:
					return PB_ERR.REQUIRED_FIELDS
			elif limit == -1 && result > 0:
				return PB_ERR.PARSE_INCOMPLETE
			return result
		
	class map_type_mm:
		func _init():
			var service
			
			_key = PBField.new("key", PB_DATA_TYPE.INT32, PB_RULE.REQUIRED, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
			_key.is_map_field = true
			service = PBServiceField.new()
			service.field = _key
			data[_key.tag] = service
			
			_value = PBField.new("value", PB_DATA_TYPE.MESSAGE, PB_RULE.REQUIRED, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
			_value.is_map_field = true
			service = PBServiceField.new()
			service.field = _value
			service.func_ref = Callable(self, "new_value")
			data[_value.tag] = service
			
		var data = {}
		
		var _key: PBField
		func get_key() -> int:
			return _key.value
		func clear_key() -> void:
			data[1].state = PB_SERVICE_STATE.UNFILLED
			_key.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
		func set_key(value : int) -> void:
			_key.value = value
		
		var _value: PBField
		func get_value() -> ObjectA:
			return _value.value
		func clear_value() -> void:
			data[2].state = PB_SERVICE_STATE.UNFILLED
			_value.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
		func new_value() -> ObjectA:
			_value.value = ObjectA.new()
			return _value.value
		
		func _to_string() -> String:
			return PBPacker.message_to_string(data)
			
		func to_bytes() -> PackedByteArray:
			return PBPacker.pack_message(data)
			
		func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
			var cur_limit = bytes.size()
			if limit != -1:
				cur_limit = limit
			var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
			if result == cur_limit:
				if PBPacker.check_required(data):
					if limit == -1:
						return PB_ERR.NO_ERRORS
				else:
					return PB_ERR.REQUIRED_FIELDS
			elif limit == -1 && result > 0:
				return PB_ERR.PARSE_INCOMPLETE
			return result
		
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class ProtobufNormalObject:
	func _init():
		var service
		
		_a = PBField.new("a", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _a
		data[_a.tag] = service
		
		_aaa = PBField.new("aaa", PB_DATA_TYPE.BYTES, PB_RULE.OPTIONAL, 3, true, DEFAULT_VALUES_3[PB_DATA_TYPE.BYTES])
		service = PBServiceField.new()
		service.field = _aaa
		data[_aaa.tag] = service
		
		_b = PBField.new("b", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 5, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _b
		data[_b.tag] = service
		
		_c = PBField.new("c", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 9, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _c
		data[_c.tag] = service
		
		_d = PBField.new("d", PB_DATA_TYPE.INT64, PB_RULE.OPTIONAL, 13, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT64])
		service = PBServiceField.new()
		service.field = _d
		data[_d.tag] = service
		
		_e = PBField.new("e", PB_DATA_TYPE.FLOAT, PB_RULE.OPTIONAL, 17, true, DEFAULT_VALUES_3[PB_DATA_TYPE.FLOAT])
		service = PBServiceField.new()
		service.field = _e
		data[_e.tag] = service
		
		_f = PBField.new("f", PB_DATA_TYPE.DOUBLE, PB_RULE.OPTIONAL, 21, true, DEFAULT_VALUES_3[PB_DATA_TYPE.DOUBLE])
		service = PBServiceField.new()
		service.field = _f
		data[_f.tag] = service
		
		_g = PBField.new("g", PB_DATA_TYPE.BOOL, PB_RULE.OPTIONAL, 25, true, DEFAULT_VALUES_3[PB_DATA_TYPE.BOOL])
		service = PBServiceField.new()
		service.field = _g
		data[_g.tag] = service
		
		_jj = PBField.new("jj", PB_DATA_TYPE.STRING, PB_RULE.OPTIONAL, 33, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
		service = PBServiceField.new()
		service.field = _jj
		data[_jj.tag] = service
		
		_kk = PBField.new("kk", PB_DATA_TYPE.MESSAGE, PB_RULE.OPTIONAL, 35, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
		service = PBServiceField.new()
		service.field = _kk
		service.func_ref = Callable(self, "new_kk")
		data[_kk.tag] = service
		
		_l = PBField.new("l", PB_DATA_TYPE.INT32, PB_RULE.REPEATED, 37, true, [])
		service = PBServiceField.new()
		service.field = _l
		data[_l.tag] = service
		
		_ll = PBField.new("ll", PB_DATA_TYPE.INT64, PB_RULE.REPEATED, 38, true, [])
		service = PBServiceField.new()
		service.field = _ll
		data[_ll.tag] = service
		
		_lll = PBField.new("lll", PB_DATA_TYPE.MESSAGE, PB_RULE.REPEATED, 39, true, [])
		service = PBServiceField.new()
		service.field = _lll
		service.func_ref = Callable(self, "add_lll")
		data[_lll.tag] = service
		
		_llll = PBField.new("llll", PB_DATA_TYPE.STRING, PB_RULE.REPEATED, 40, true, [])
		service = PBServiceField.new()
		service.field = _llll
		data[_llll.tag] = service
		
		_m = PBField.new("m", PB_DATA_TYPE.MAP, PB_RULE.REPEATED, 51, true, [])
		service = PBServiceField.new()
		service.field = _m
		service.func_ref = Callable(self, "add_empty_m")
		data[_m.tag] = service
		
		_mm = PBField.new("mm", PB_DATA_TYPE.MAP, PB_RULE.REPEATED, 52, true, [])
		service = PBServiceField.new()
		service.field = _mm
		service.func_ref = Callable(self, "add_empty_mm")
		data[_mm.tag] = service
		
		_s = PBField.new("s", PB_DATA_TYPE.INT32, PB_RULE.REPEATED, 61, true, [])
		service = PBServiceField.new()
		service.field = _s
		data[_s.tag] = service
		
		_ssss = PBField.new("ssss", PB_DATA_TYPE.STRING, PB_RULE.REPEATED, 64, true, [])
		service = PBServiceField.new()
		service.field = _ssss
		data[_ssss.tag] = service
		
	var data = {}
	
	var _a: PBField
	func get_a() -> int:
		return _a.value
	func clear_a() -> void:
		data[1].state = PB_SERVICE_STATE.UNFILLED
		_a.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_a(value : int) -> void:
		_a.value = value
	
	var _aaa: PBField
	func get_aaa() -> PackedByteArray:
		return _aaa.value
	func clear_aaa() -> void:
		data[3].state = PB_SERVICE_STATE.UNFILLED
		_aaa.value = DEFAULT_VALUES_3[PB_DATA_TYPE.BYTES]
	func set_aaa(value : PackedByteArray) -> void:
		_aaa.value = value
	
	var _b: PBField
	func get_b() -> int:
		return _b.value
	func clear_b() -> void:
		data[5].state = PB_SERVICE_STATE.UNFILLED
		_b.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_b(value : int) -> void:
		_b.value = value
	
	var _c: PBField
	func get_c() -> int:
		return _c.value
	func clear_c() -> void:
		data[9].state = PB_SERVICE_STATE.UNFILLED
		_c.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_c(value : int) -> void:
		_c.value = value
	
	var _d: PBField
	func get_d() -> int:
		return _d.value
	func clear_d() -> void:
		data[13].state = PB_SERVICE_STATE.UNFILLED
		_d.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT64]
	func set_d(value : int) -> void:
		_d.value = value
	
	var _e: PBField
	func get_e() -> float:
		return _e.value
	func clear_e() -> void:
		data[17].state = PB_SERVICE_STATE.UNFILLED
		_e.value = DEFAULT_VALUES_3[PB_DATA_TYPE.FLOAT]
	func set_e(value : float) -> void:
		_e.value = value
	
	var _f: PBField
	func get_f() -> float:
		return _f.value
	func clear_f() -> void:
		data[21].state = PB_SERVICE_STATE.UNFILLED
		_f.value = DEFAULT_VALUES_3[PB_DATA_TYPE.DOUBLE]
	func set_f(value : float) -> void:
		_f.value = value
	
	var _g: PBField
	func get_g() -> bool:
		return _g.value
	func clear_g() -> void:
		data[25].state = PB_SERVICE_STATE.UNFILLED
		_g.value = DEFAULT_VALUES_3[PB_DATA_TYPE.BOOL]
	func set_g(value : bool) -> void:
		_g.value = value
	
	var _jj: PBField
	func get_jj() -> String:
		return _jj.value
	func clear_jj() -> void:
		data[33].state = PB_SERVICE_STATE.UNFILLED
		_jj.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
	func set_jj(value : String) -> void:
		_jj.value = value
	
	var _kk: PBField
	func get_kk() -> ObjectA:
		return _kk.value
	func clear_kk() -> void:
		data[35].state = PB_SERVICE_STATE.UNFILLED
		_kk.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
	func new_kk() -> ObjectA:
		_kk.value = ObjectA.new()
		return _kk.value
	
	var _l: PBField
	func get_l() -> Array:
		return _l.value
	func clear_l() -> void:
		data[37].state = PB_SERVICE_STATE.UNFILLED
		_l.value = []
	func add_l(value : int) -> void:
		_l.value.append(value)
	
	var _ll: PBField
	func get_ll() -> Array:
		return _ll.value
	func clear_ll() -> void:
		data[38].state = PB_SERVICE_STATE.UNFILLED
		_ll.value = []
	func add_ll(value : int) -> void:
		_ll.value.append(value)
	
	var _lll: PBField
	func get_lll() -> Array:
		return _lll.value
	func clear_lll() -> void:
		data[39].state = PB_SERVICE_STATE.UNFILLED
		_lll.value = []
	func add_lll() -> ObjectA:
		var element = ObjectA.new()
		_lll.value.append(element)
		return element
	
	var _llll: PBField
	func get_llll() -> Array:
		return _llll.value
	func clear_llll() -> void:
		data[40].state = PB_SERVICE_STATE.UNFILLED
		_llll.value = []
	func add_llll(value : String) -> void:
		_llll.value.append(value)
	
	var _m: PBField
	func get_raw_m():
		return _m.value
	func get_m():
		return PBPacker.construct_map(_m.value)
	func clear_m():
		data[51].state = PB_SERVICE_STATE.UNFILLED
		_m.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MAP]
	func add_empty_m() -> ProtobufNormalObject.map_type_m:
		var element = ProtobufNormalObject.map_type_m.new()
		_m.value.append(element)
		return element
	func add_m(a_key, a_value) -> void:
		var idx = -1
		for i in range(_m.value.size()):
			if _m.value[i].get_key() == a_key:
				idx = i
				break
		var element = ProtobufNormalObject.map_type_m.new()
		element.set_key(a_key)
		element.set_value(a_value)
		if idx != -1:
			_m.value[idx] = element
		else:
			_m.value.append(element)
	
	var _mm: PBField
	func get_raw_mm():
		return _mm.value
	func get_mm():
		return PBPacker.construct_map(_mm.value)
	func clear_mm():
		data[52].state = PB_SERVICE_STATE.UNFILLED
		_mm.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MAP]
	func add_empty_mm() -> ProtobufNormalObject.map_type_mm:
		var element = ProtobufNormalObject.map_type_mm.new()
		_mm.value.append(element)
		return element
	func add_mm(a_key) -> ProtobufNormalObject.ObjectA:
		var idx = -1
		for i in range(_mm.value.size()):
			if _mm.value[i].get_key() == a_key:
				idx = i
				break
		var element = ProtobufNormalObject.map_type_mm.new()
		element.set_key(a_key)
		if idx != -1:
			_mm.value[idx] = element
		else:
			_mm.value.append(element)
		return element.new_value()
	
	var _s: PBField
	func get_s() -> Array:
		return _s.value
	func clear_s() -> void:
		data[61].state = PB_SERVICE_STATE.UNFILLED
		_s.value = []
	func add_s(value : int) -> void:
		_s.value.append(value)
	
	var _ssss: PBField
	func get_ssss() -> Array:
		return _ssss.value
	func clear_ssss() -> void:
		data[64].state = PB_SERVICE_STATE.UNFILLED
		_ssss.value = []
	func add_ssss(value : String) -> void:
		_ssss.value.append(value)
	
	class map_type_m:
		func _init():
			var service
			
			_key = PBField.new("key", PB_DATA_TYPE.INT32, PB_RULE.REQUIRED, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
			_key.is_map_field = true
			service = PBServiceField.new()
			service.field = _key
			data[_key.tag] = service
			
			_value = PBField.new("value", PB_DATA_TYPE.STRING, PB_RULE.REQUIRED, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.STRING])
			_value.is_map_field = true
			service = PBServiceField.new()
			service.field = _value
			data[_value.tag] = service
			
		var data = {}
		
		var _key: PBField
		func get_key() -> int:
			return _key.value
		func clear_key() -> void:
			data[1].state = PB_SERVICE_STATE.UNFILLED
			_key.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
		func set_key(value : int) -> void:
			_key.value = value
		
		var _value: PBField
		func get_value() -> String:
			return _value.value
		func clear_value() -> void:
			data[2].state = PB_SERVICE_STATE.UNFILLED
			_value.value = DEFAULT_VALUES_3[PB_DATA_TYPE.STRING]
		func set_value(value : String) -> void:
			_value.value = value
		
		func _to_string() -> String:
			return PBPacker.message_to_string(data)
			
		func to_bytes() -> PackedByteArray:
			return PBPacker.pack_message(data)
			
		func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
			var cur_limit = bytes.size()
			if limit != -1:
				cur_limit = limit
			var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
			if result == cur_limit:
				if PBPacker.check_required(data):
					if limit == -1:
						return PB_ERR.NO_ERRORS
				else:
					return PB_ERR.REQUIRED_FIELDS
			elif limit == -1 && result > 0:
				return PB_ERR.PARSE_INCOMPLETE
			return result
		
	class map_type_mm:
		func _init():
			var service
			
			_key = PBField.new("key", PB_DATA_TYPE.INT32, PB_RULE.REQUIRED, 1, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
			_key.is_map_field = true
			service = PBServiceField.new()
			service.field = _key
			data[_key.tag] = service
			
			_value = PBField.new("value", PB_DATA_TYPE.MESSAGE, PB_RULE.REQUIRED, 2, true, DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE])
			_value.is_map_field = true
			service = PBServiceField.new()
			service.field = _value
			service.func_ref = Callable(self, "new_value")
			data[_value.tag] = service
			
		var data = {}
		
		var _key: PBField
		func get_key() -> int:
			return _key.value
		func clear_key() -> void:
			data[1].state = PB_SERVICE_STATE.UNFILLED
			_key.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
		func set_key(value : int) -> void:
			_key.value = value
		
		var _value: PBField
		func get_value() -> ObjectA:
			return _value.value
		func clear_value() -> void:
			data[2].state = PB_SERVICE_STATE.UNFILLED
			_value.value = DEFAULT_VALUES_3[PB_DATA_TYPE.MESSAGE]
		func new_value() -> ObjectA:
			_value.value = ObjectA.new()
			return _value.value
		
		func _to_string() -> String:
			return PBPacker.message_to_string(data)
			
		func to_bytes() -> PackedByteArray:
			return PBPacker.pack_message(data)
			
		func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
			var cur_limit = bytes.size()
			if limit != -1:
				cur_limit = limit
			var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
			if result == cur_limit:
				if PBPacker.check_required(data):
					if limit == -1:
						return PB_ERR.NO_ERRORS
				else:
					return PB_ERR.REQUIRED_FIELDS
			elif limit == -1 && result > 0:
				return PB_ERR.PARSE_INCOMPLETE
			return result
		
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
class ProtobufSimpleObject:
	func _init():
		var service
		
		_c = PBField.new("c", PB_DATA_TYPE.INT32, PB_RULE.OPTIONAL, 9, true, DEFAULT_VALUES_3[PB_DATA_TYPE.INT32])
		service = PBServiceField.new()
		service.field = _c
		data[_c.tag] = service
		
		_g = PBField.new("g", PB_DATA_TYPE.BOOL, PB_RULE.OPTIONAL, 25, true, DEFAULT_VALUES_3[PB_DATA_TYPE.BOOL])
		service = PBServiceField.new()
		service.field = _g
		data[_g.tag] = service
		
	var data = {}
	
	var _c: PBField
	func get_c() -> int:
		return _c.value
	func clear_c() -> void:
		data[9].state = PB_SERVICE_STATE.UNFILLED
		_c.value = DEFAULT_VALUES_3[PB_DATA_TYPE.INT32]
	func set_c(value : int) -> void:
		_c.value = value
	
	var _g: PBField
	func get_g() -> bool:
		return _g.value
	func clear_g() -> void:
		data[25].state = PB_SERVICE_STATE.UNFILLED
		_g.value = DEFAULT_VALUES_3[PB_DATA_TYPE.BOOL]
	func set_g(value : bool) -> void:
		_g.value = value
	
	func _to_string() -> String:
		return PBPacker.message_to_string(data)
		
	func to_bytes() -> PackedByteArray:
		return PBPacker.pack_message(data)
		
	func from_bytes(bytes : PackedByteArray, offset : int = 0, limit : int = -1) -> int:
		var cur_limit = bytes.size()
		if limit != -1:
			cur_limit = limit
		var result = PBPacker.unpack_message(data, bytes, offset, cur_limit)
		if result == cur_limit:
			if PBPacker.check_required(data):
				if limit == -1:
					return PB_ERR.NO_ERRORS
			else:
				return PB_ERR.REQUIRED_FIELDS
		elif limit == -1 && result > 0:
			return PB_ERR.PARSE_INCOMPLETE
		return result
	
################ USER DATA END #################
