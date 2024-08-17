import 'package:flutter/material.dart';
import 'package:useful_services_frontend/tabs/consumption_convertion_tab.dart';
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
            label: 'Consumption Convertion',
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
        return const ConsumptionConvertionTab();
      case 1:
        return const OtherTab();
      default:
        return const OtherTab();
    }
  }

  String _getTabTitle() {
    switch (_selectedTab) {
      case 0:
        return "Consumption Convertion";
      case 1:
        return "Other";
      default:
        return "Other";
    }
  }
}
