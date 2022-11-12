import 'package:expandable_attempt/data/models/schedule_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/cubit/saved_cubit.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail(
      {super.key,
      required this.title,
      required this.color,
      required this.scheduleItem});

  final Schedule scheduleItem;
  final String title;
  final MaterialAccentColor color;

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scheduleItem.title),
        centerTitle: true,
      ),
      body: Text(widget.scheduleItem.description),
    );
  }
}
