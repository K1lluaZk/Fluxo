// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 1;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      id: fields[0] as String,
      titulo: fields[1] as String,
      descripcion: fields[2] as String,
      fecha: fields[3] as DateTime,
      monto: fields[4] as double,
      ingreso: fields[5] as bool,
      completada: fields[6] as bool,
      fechaVencimiento: fields[7] as DateTime?,
      recordar: fields[8] as bool,
      diasAntes: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titulo)
      ..writeByte(2)
      ..write(obj.descripcion)
      ..writeByte(3)
      ..write(obj.fecha)
      ..writeByte(4)
      ..write(obj.monto)
      ..writeByte(5)
      ..write(obj.ingreso)
      ..writeByte(6)
      ..write(obj.completada)
      ..writeByte(7)
      ..write(obj.fechaVencimiento)
      ..writeByte(8)
      ..write(obj.recordar)
      ..writeByte(9)
      ..write(obj.diasAntes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
