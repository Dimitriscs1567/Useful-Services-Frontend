import 'package:flutter/material.dart';
import 'package:useful_services_frontend/tabs/compare_consumption_tab.dart';
import 'package:useful_services_frontend/tabs/consumption_convertions.dart';
import 'package:useful_services_frontend/tabs/other_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;

  void _onItemTapped(int tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTabTitle()),
      ),
      body: SafeArea(
        child: _getTabScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.gas_meter),
            label: 'Compare Consumption',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Consumption Convertions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.device_unknown),
            label: 'Other',
          ),
        ],
        currentIndex: _selectedTab,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getTabScreen() {
    switch (_selectedTab) {
      case 0:
        return const CompareConsumptionTab();
      case 1:
        return const ConsumptionConvertions();
      case 2:
        return const OtherTab();
      default:
        return const CompareConsumptionTab();
    }
  }

  String _getTabTitle() {
    switch (_selectedTab) {
      case 0:
        return "Compare Consumption";
      case 1:
        return "Consumption Convertions";
      case 2:
        return "Other";
      default:
        return "Compare Consumption";
    }
  }
}
