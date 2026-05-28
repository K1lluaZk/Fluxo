// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movimiento.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovimientoAdapter extends TypeAdapter<Movimiento> {
  @override
  final int typeId = 0;

  @override
  Movimiento read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movimiento(
      id: fields[0] as String,
      titulo: fields[1] as String,
      monto: fields[2] as double,
      ingreso: fields[3] as bool,
      fecha: fields[4] as DateTime,
      categoria: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Movimiento obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titulo)
      ..writeByte(2)
      ..write(obj.monto)
      ..writeByte(3)
      ..write(obj.ingreso)
      ..writeByte(4)
      ..write(obj.fecha)
      ..writeByte(5)
      ..write(obj.categoria);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovimientoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
