import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/core/utils/constants.dart';
import 'package:letaskono_flutter/features/users/presentation/widgets/MultiSelectionDropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/user_bloc.dart';
import 'CircularText.dart';

class FilterBottomSheet extends StatefulWidget {
  final UserBloc userBloc;

  const FilterBottomSheet(this.userBloc, {super.key});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SharedPreferences prefs;
  RangeValues ageRange = const RangeValues(18, 80); // Default range
  List<String> selectedMaritalStatus = [];
  List<String> selectedLe7ya = [];
  List<String> selectedHijab = [];
  String ordering = '';
  String gender = '';
  List<String> selectedCountries = [];
  List<String> selectedNationalities = [];
  List<String> availableStates = [];
  List<String> selectedStates = [];
  Map<String, String> orders = {
    '': "",
    'العمر-تصاعدي': "age",
    'العمر-تنازلي': "-age",
    'أخر ظهور-تصاعدي': "last_seen",
    'أخر ظهور-تنازلي': "-last_seen",
    'تاريخ التسجيل-تصاعدي': "user__date_joined",
    'تاريخ التسجيل-تنازلي': "-user__date_joined",
  };

  @override
  void initState() {
    super.initState();
    prefs = GetIt.instance<SharedPreferences>();
    _loadPreferences();
    _updateStatesForCountries(selectedCountries);
  }

  void _loadPreferences() async {
    setState(() {
      ageRange = RangeValues(
        prefs.getDouble('filter_age_min') ?? 18,
        prefs.getDouble('filter_age_max') ?? 100,
      );
      selectedMaritalStatus =
          prefs.getStringList('filter_marital_status') ?? List.empty();
      selectedCountries =
          prefs.getStringList('filter_countries') ?? List.empty();
      selectedHijab = prefs.getStringList('filter_hijabs') ?? List.empty();
      selectedLe7ya = prefs.getStringList('filter_le7yas') ?? List.empty();
      selectedNationalities =
          prefs.getStringList('filter_nationalities') ?? List.empty();
      gender = prefs.getString('filter_gender') ?? 'F';

      // ordering = prefs.getString('ordering') ?? 'profile__age';
    });
  }

  void _updateStatesForCountries(List<String> countries) {
    setState(() {
      // Clear the selected states when updating
      selectedStates = [];
      // Collect the states for all selected countries and cast them to List<String>
      availableStates = countries
          .expand((country) => Constants.countryStateMap[country] ?? [])
          .toList()
          .cast<String>(); // Explicitly cast to List<String>
      selectedStates = prefs.getStringList('filter_states') ?? List.empty();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height:
          MediaQuery.of(context).size.height * 0.9, // 90% of the screen height
      child: Column(
        children: [
          // Header and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'تصفية البحث',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
          const Divider(),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensures no unnecessary space
                children: [
                  // Age Slider Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'اختر العمر المناسب',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          CircularText(
                            text: ageRange.start.round().toString(),
                            size: 24,
                            borderColor: const Color(0xFFDD88CF),
                            borderWidth: 0.8,
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF22172A),
                            ),
                          ),
                          Expanded(
                            child: RangeSlider(
                              activeColor:
                                  Theme.of(context).colorScheme.primary,
                              values: ageRange,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              labels: RangeLabels(
                                ageRange.start.round().toString(),
                                ageRange.end.round().toString(),
                              ),
                              onChanged: (RangeValues newRange) {
                                setState(() {
                                  ageRange = newRange;
                                });
                              },
                            ),
                          ),
                          CircularText(
                            text: ageRange.end.round().toString(),
                            size: 24,
                            borderColor: Theme.of(context).colorScheme.primary,
                            borderWidth: 0.8,
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),
                  // Marital Status Dropdown
                  MultiSelectionDropdown(
                    title: 'اختر الحالة الاجتماعية',
                    items: gender == 'F'
                        ? ['أرملة', 'مطلقة', 'عزباء']
                        : ['أعزب', 'متزوج', 'أرمل', 'مطلق'],
                    selectedItems: selectedMaritalStatus,
                    onSelected: (List<String> values) {
                      setState(() {
                        selectedMaritalStatus = values;
                      });
                    },
                    hintText: 'الحالة الاجتماعية',
                  ),
                  const SizedBox(height: 16),
                  // Countries Dropdown
                  MultiSelectionDropdown(
                    title: 'اختر بلد الإقامة',
                    items: Constants.countryStateMap.keys.toList(),
                    selectedItems: selectedCountries,
                    onSelected: (List<String> values) {
                      setState(() {
                        selectedCountries = values;
                      });
                      _updateStatesForCountries(selectedCountries);
                    },
                    hintText: 'بلد الإقامة',
                  ),
                  const SizedBox(height: 16),
                  // States Dropdown
                  MultiSelectionDropdown(
                    title: 'اختر المحافظة',
                    items: availableStates,
                    selectedItems: selectedStates,
                    onSelected: (List<String> values) {
                      setState(() {
                        selectedStates = values;
                      });
                    },
                    isEnabled: availableStates.isNotEmpty,
                    hintText: 'المحافظة',
                  ),
                  const SizedBox(height: 16),
                  // Nationalities Dropdown
                  MultiSelectionDropdown(
                    title: 'اختر الجنسية',
                    items: Constants.countryStateMap.keys.toList(),
                    selectedItems: selectedNationalities,
                    onSelected: (List<String> values) {
                      setState(() {
                        selectedNationalities = values;
                      });
                    },
                    hintText: 'الجنسية',
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: gender == 'M',
                    child: MultiSelectionDropdown(
                      title: 'اختر الشكل',
                      items: const ['ملتحي', 'لحية خفيفة', 'أملس'],
                      selectedItems: selectedLe7ya,
                      onSelected: (List<String> values) {
                        setState(() {
                          selectedLe7ya = values;
                        });
                      },
                      hintText: 'الشكل',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: gender == 'F',
                    child: MultiSelectionDropdown(
                      title: 'اختر شكل الحجاب',
                      items: const [
                        'منتقبة سواد',
                        'منتقبة ألوان',
                        'مختمرة',
                        'طرح وفساتين',
                        'طرح وبناطيل',
                        'غير محجبة'
                      ],
                      selectedItems: selectedHijab,
                      onSelected: (List<String> values) {
                        setState(() {
                          selectedHijab = values;
                        });
                      },
                      hintText: 'شكل الحجاب',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Constant Apply Filters Button
          SafeArea(
            child: Row(
              children: [
                // Second Button: Takes 2/3 of the width
                Flexible(
                  flex: 4, // Relative weight for 2/3 width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size.fromHeight(50), // Consistent height
                    ),
                    onPressed: () {
                      widget.userBloc.add(
                        ApplyFiltersEvent(
                          maritalStatus: selectedMaritalStatus,
                          ageMin: ageRange.start.round(),
                          ageMax: ageRange.end.round(),
                          ordering: ordering,
                          hijabs: selectedHijab,
                          le7yas: selectedLe7ya,
                          countries: selectedCountries,
                          nationalities: selectedNationalities,
                          states: selectedStates,
                          gender: gender,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          'تصفية البحث',
                          textAlign: TextAlign.center,
                        )),
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8), // Add spacing between buttons

                // First Button: Takes 1/2 of the width
                Flexible(
                  flex: 2, // Relative weight for 1/2 width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        ),
                        minimumSize: const Size.fromHeight(50),
                        // Consistent height
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        foregroundColor: Colors.grey,
                        elevation: 0),
                    onPressed: () {
                      widget.userBloc.add(
                        ApplyFiltersEvent(
                          maritalStatus: [],
                          ageMin: 18,
                          ageMax: 100,
                          ordering: ordering,
                          countries: [],
                          states: [],
                          gender: gender,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.refresh_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MultiSelect Widget for states
  Widget _buildMultiSelect({
    required String label,
    required List<String> selectedItems,
    required List<String> availableItems,
    required Function(List<String>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Wrap(
          spacing: 10.0,
          children: availableItems
              .map((item) => ChoiceChip(
                    label: Text(item),
                    selected: selectedItems.contains(item),
                    onSelected: (selected) {
                      final newSelectedItems = List<String>.from(selectedItems);
                      if (selected) {
                        newSelectedItems.add(item);
                      } else {
                        newSelectedItems.remove(item);
                      }
                      onChanged(newSelectedItems);
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
