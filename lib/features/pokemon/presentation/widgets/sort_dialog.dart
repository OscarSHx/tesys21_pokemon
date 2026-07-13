import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';

class SortDialog extends StatelessWidget {
  const SortDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(onTap: () => Navigator.pop(context)),
          Positioned(
            top: 72,
            right: 16,
            width: 200,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildHeaderPopUp(), _buildRadiosSort()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderPopUp() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      child: Text(
        'Ordenar por:',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRadiosSort() {
    return Container(
      margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          return RadioGroup(
            groupValue: provider.currentOrder,
            onChanged: (PokemonOrder? value) {
              if (value != null) {
                provider.changeSort(value);
                Navigator.pop(context);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<PokemonOrder>(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: const Text(
                    'Número',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: PokemonOrder.number,
                ),
                RadioListTile<PokemonOrder>(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: const Text(
                    'Nombre',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: PokemonOrder.name,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
