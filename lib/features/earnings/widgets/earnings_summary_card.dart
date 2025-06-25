// lib/features/earnings/widgets/earnings_summary_card.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/core/theme/app_colors.dart';

class EarningsSummaryCard extends StatelessWidget {
  // --- SOLUCIÓN: Añadir el parámetro requerido ---
  final double availableBalance;

  const EarningsSummaryCard({
    super.key,
    required this.availableBalance, // Marcarlo como requerido
  });
  // --- FIN DE LA SOLUCIÓN ---

  @override
  Widget build(BuildContext context) {
    // Formateador para mostrar el dinero con formato de moneda (ej: $1,234.50)
    final currencyFormatter =
    NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // Un gradiente atractivo para la tarjeta principal
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0A84FF).withOpacity(0.9), // Un azul vibrante
            const Color(0xFF0A84FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance Disponible',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            // Ahora se usa el valor dinámico que pasamos, formateado como moneda
            currencyFormatter.format(availableBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 60,
            child: LineChart(_buildChartData()),
          ),
        ],
      ),
    );
  }

  // El gráfico se mantiene, ya que es principalmente decorativo y visual.
  LineChartData _buildChartData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3), FlSpot(1, 1.5), FlSpot(2, 4), FlSpot(3, 2.4),
            FlSpot(4, 5), FlSpot(5, 3), FlSpot(6, 4.1), FlSpot(7, 3.5),
          ],
          isCurved: true,
          color: Colors.white, // Color de la línea del gráfico
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}