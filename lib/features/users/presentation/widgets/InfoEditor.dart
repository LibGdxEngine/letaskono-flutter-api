import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/core/utils/CustomTextField.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';
import 'package:letaskono_flutter/core/utils/SingleSelectionDropdown.dart';
import 'package:letaskono_flutter/core/utils/constants.dart';
import 'package:letaskono_flutter/features/users/domain/entities/UserModifyEntity.dart';
import 'package:letaskono_flutter/features/users/presentation/bloc/user_bloc.dart';

import '../../domain/entities/UserDetailsEntity.dart';

class InfoEditor extends StatefulWidget {
  final UserBloc userBloc;

  const InfoEditor({super.key, required this.userBloc});

  @override
  State<InfoEditor> createState() => _InfoEditorState();
}

class _InfoEditorState extends State<InfoEditor> {
  // Fields to track changes
  bool _hasChanges = false;
  bool _isInitializing = false; // New flag for initialization
  final Map<String, dynamic> _changedValues = {};

  // Dropdown selections
  String? _selectedGender;
  String? _selectedSkinColor;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedFatherKnowAboutApp;
  String? _selectedFatherAcceptMarriageWithoutQaima;
  bool? _selectedYouAcceptMarriageWithoutQaima;
  String? _selectedEducationLevel;
  int? _selectedQuranParts;
  String? _selectedPrayFrequency;
  String? _selectedAzkarPractice;
  String? _selectedLe7ya;
  String? _selectedHijab;

  // Form keys
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _religiousInfoFormKey = GlobalKey<FormState>();

  // Form controllers
  final whoListenToController = TextEditingController();
  final hobbiesController = TextEditingController();
  final disabilitiesController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final skinColorController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final professionController = TextEditingController();
  final aboutMeController = TextEditingController();
  final aboutMyPartnerController = TextEditingController();
  final boysController = TextEditingController();
  final girlsController = TextEditingController();
  final wantIslamicMarriageController = TextEditingController();
  final relationWithFamilyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Add listeners to all controllers to detect changes
    final Map<String, TextEditingController> controllers = {
      'who_do_you_listen_to': whoListenToController,
      'hobbies': hobbiesController,
      'disabilities': disabilitiesController,
      'height': heightController,
      'age': ageController,
      'weight': weightController,
      'skin_color': skinColorController,
      'state': stateController,
      'country': countryController,
      'city': cityController,
      'profession': professionController,
      'about': aboutMeController,
      'looking_for': aboutMyPartnerController,
      'relation_with_family': relationWithFamilyController,
    };

    controllers.forEach((key, controller) {
      controller.addListener(() {
        if (controller.text.isNotEmpty) {
          _setFieldChanged(key, controller.text); // Use key from the map
        }
      });
    });
  }

  void _setFieldChanged(String key, dynamic value) {
    if (_isInitializing) return; // Ignore changes during initialization
    if (_changedValues[key] != value) {
      setState(() {
        _changedValues[key] = value;
        _hasChanges = true;
      });
    }
  }

  void _setDropdownChanged(String key, dynamic newValue, dynamic currentValue) {
    if (_isInitializing) return; // Ignore changes during initialization
    if (newValue != currentValue) {
      setState(() {
        _changedValues[key] = newValue;
        _hasChanges = true; // Show FAB when a change is detected
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بيانات الحساب'),
      ),
      floatingActionButton: _hasChanges
          ? FloatingActionButton.extended(
              onPressed: _submitChanges,
              label: const Row(
                children: [
                  Icon(Icons.check),
                  SizedBox(width: 8),
                  Text('حفظ التغييرات'),
                ],
              ),
            )
          : null,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserDetailsLoaded) {
            _initUserData(state.user);
          } else if (state is UserUpdatedFailed) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
            // widget.userBloc.add(FetchCurrentUserEvent());
          } else if (state is UserUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث البيانات')));
            // Reset the state after submission
            setState(() {
              _hasChanges = false;
              _changedValues.clear();
            });
          }
        },
        buildWhen: (previous, current) {
          // Only rebuild when certain conditions are met
          return current is UserDetailsLoaded;
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return ExpandingCircleProgress();
          } else if (state is UserDetailsLoaded) {
            String? userState = state.user.isAccountConfirmed != true
                ? "في انتظار المراجعة"
                : "مفعل";
            if (state.user.isBlocked == true) {
              userState = "محظور";
            } else if (state.user.isDisabled == true) {
              userState = "معطل";
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            'الكود : ${state.user.code}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SelectableText(
                            'حالة الحساب : ${userState}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.6)),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'البيانات العامة:',
                            style: Theme.of(context).textTheme.headlineMedium,
                          )
                        ],
                      )),
                  buildBasicInfoStep(context),
                  buildLocationStep(context),
                  buildPersonalInfoStep(context),
                  buildReligiousInfoStep(context),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            );
          } else {
            return ExpandingCircleProgress();
          }
        },
      ),
    );
  }

  void _submitChanges() {
    // Submit the changed values
    if (_changedValues.isNotEmpty) {
      print('Changed values: $_changedValues');
      final pce = ProfileChangeEntity.fromJson(_changedValues);
      print(pce.toJson());
      widget.userBloc.add(UpdateUserProfile(pce));
    }
  }

  void _initUserData(UserDetailsEntity user) {
    _isInitializing = true; // Start initialization
    setState(() {
      _selectedGender = user.gender;
      heightController.text = user.height.toString();
      weightController.text = user.weight.toString();
      ageController.text = user.age.toString();
      _selectedSkinColor = user.skinColor;
      _selectedCountry = user.country;
      countryController.text = user.country ?? '';
      _selectedState = user.state;
      stateController.text = user.state ?? '';
      cityController.text = user.city ?? '';
      _selectedEducationLevel = user.educationLevel;
      professionController.text = user.profession ?? '';
      aboutMeController.text = user.aboutMe ?? '';
      aboutMyPartnerController.text = user.lookingFor ?? '';
      _selectedQuranParts = user.memorizedQuranParts;
      relationWithFamilyController.text = user.relationWithFamily ?? '';
      _selectedPrayFrequency = user.prayerFrequency;
      _selectedAzkarPractice = user.azkar;
      _selectedLe7ya = user.le7ya;
      _selectedHijab = user.hijab;
      disabilitiesController.text = user.disabilities ?? '';
      hobbiesController.text = user.hobbies ?? '';
      whoListenToController.text = user.whoDoYouListenTo ?? '';
      _selectedFatherKnowAboutApp = user.fatherKnowAboutThisWebsite;
      _selectedFatherAcceptMarriageWithoutQaima = user.fatherAcceptMarriageWithoutQaima;
      _selectedYouAcceptMarriageWithoutQaima = user.youAcceptMarriageWithoutQaima;
    });
    _isInitializing = false; // Start initialization
  }

  Widget buildBasicInfoStep(BuildContext context) {
    final List<String> _skinColors = [
      'فاتح جدًا',
      'فاتح',
      'متوسط',
      'برونزي',
      'غامق',
      'داكن جدًا',
    ];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _basicInfoFormKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                topText: 'العمر',
                controller: ageController,
                hintText: 'العمر',
                keyboardType: TextInputType.number,
                preIconPadding: 11,
                prefixIcon: const Icon(Icons.numbers_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل عمرك';
                  }
                  if (int.tryParse(value) == null) {
                    return 'يرجى اختيار رقم صحيح';
                  }
                  if (int.parse(value) <= 0) {
                    return 'يجب أن يكون عمرك أكبر من ذلك';
                  }
                  if (int.parse(value) >= 100) {
                    return 'أنت كبير للغاية للتسجيل لدينا';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                topText: 'الطول',
                controller: heightController,
                hintText: 'الطول',
                keyboardType: const TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                preIconPadding: 11,
                prefixIcon: Image.asset(
                  "assets/images/height_icon.png",
                  width: 15,
                  height: 15,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل طولك';
                  }
                  if (double.tryParse(value) == null) {
                    return 'يرجى اختيار رقم صحيح';
                  }
                  if (double.tryParse(value)! >= 220.0) {
                    return 'يجب أن يكون طولك اقل من ذلك';
                  }
                  if (double.tryParse(value)! <= 40) {
                    return 'يجب أن يكون طولك أكثر من ذلك';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                topText: 'الوزن',
                controller: weightController,
                hintText: 'الوزن',
                keyboardType: TextInputType.number,
                preIconPadding: 11,
                prefixIcon: Image.asset(
                  "assets/images/weight_icon.png",
                  width: 15,
                  height: 15,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل وزنك';
                  }
                  if (double.tryParse(value) == null) {
                    return 'يرجى اختيار رقم صحيح';
                  }
                  if (double.tryParse(value)! >= 250) {
                    return 'يجب أن يكون وزك أقل من ذلك';
                  }
                  if (double.tryParse(value)! <= 25) {
                    return 'يجب أن يكون وزنك أكبر من ذلك';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SingleSelectionDropdown(
                topText: 'لون البشرة',
                title: 'لون البشرة',
                items: _skinColors,
                selectedItem: _selectedSkinColor,
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  _setDropdownChanged("skinColor", item, _selectedSkinColor);
                  setState(() {
                    _selectedSkinColor = item;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر لون بشرتك';
                  }
                  return null;
                },
                hintText: 'اختر لون البشرة',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLocationStep(BuildContext context) {
    // Predefined lists of cities and countries
    final Map<String, String> fatherKnowsOptions = {
      'نعم': 'Yes, knows',
      "لا يعلم ولكن يمكنني إخباره": 'No',
      "لا يعلم وأحتاج مساعدة لإخباره": 'No, but I can tell him later',
    };
    final Map<String, String> fatherAcceptMarriageWithoutQaima = {
      'نعم': 'Yes',
      'لا': 'No',
      'ربما': 'Maybe',
    };
    final Map<String, String> youAcceptMarriageWithoutQaima = {
      'نعم': 'Yes',
      'لا': 'No',
    };

    // Update phone code when country is selected
    void _onCountryChanged(String? country) {
      _setDropdownChanged("country", country, _selectedCountry);
      setState(() {
        _selectedCountry = country;
        // Reset city when country changes
        _selectedState = null;
      });
    }

    return Form(
      key: _locationFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleSelectionDropdown(
                topText: 'بلد الإقامة',
                title: 'بلد الإقامة',
                items: Constants.countryStateMap.keys.toList(),
                selectedItem: _selectedCountry,
                onSelected: _onCountryChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر بلد الإقامة';
                  }
                  return null;
                },
                hintText: 'اختر بلد الإقامة',
              ),
              const SizedBox(height: 16),
              if (_selectedCountry != null) ...[
                SingleSelectionDropdown(
                  topText: 'المحافظة',
                  title: 'المحافظة',
                  items: Constants.countryStateMap[_selectedCountry]!.toList(),
                  selectedItem: _selectedState,
                  onSelected: (state) {
                    _setDropdownChanged("state", state, _selectedState);
                    setState(() {
                      _selectedState = state;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك اختر محافظتك';
                    }
                    return null;
                  },
                  isEnabled: _selectedCountry != null,
                  hintText: 'اختر محافظتك',
                ),
                const SizedBox(height: 16),
              ],
              CustomTextField(
                topText: 'القرية/المدينة',
                controller: cityController,
                hintText: 'القرية/المدينة',
                keyboardType: TextInputType.text,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك أدخل المدينة التي تعيش فيها';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _selectedGender == 'F'
                  ? Column(
                      children: [
                        SingleSelectionDropdown(
                          topText:
                              'هل يعلم ولي أمرك بشأن تسجيلك في هذا التطبيق ؟',
                          title:
                              'هل يعلم ولي أمرك بشأن تسجيلك في هذا التطبيق ؟',
                          items: fatherKnowsOptions.keys.toList(),
                          selectedItem: _selectedFatherKnowAboutApp,
                          onSelected: (item) => {
                            _setDropdownChanged("father_knows", item,
                                _selectedFatherKnowAboutApp),
                            setState(() {
                              _selectedFatherKnowAboutApp = item;
                            })
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب أن تحددي أحد الخيارات هنا';
                            }
                            return null;
                          },
                          hintText: 'هل ولي أمرك يعلم بتسجيلك هنا ؟',
                        ),
                        const SizedBox(height: 16),
                        SingleSelectionDropdown(
                          topText: 'هل يعلم يقبل ولي أمرك بالزواج الشرعي ؟',
                          title: 'هل يعلم يقبل ولي أمرك بالزواج الشرعي ؟',
                          items: fatherAcceptMarriageWithoutQaima.keys.toList(),
                          selectedItem:
                              _selectedFatherAcceptMarriageWithoutQaima,
                          onSelected: (item) => {
                            _setDropdownChanged("father_accepts", item,
                                _selectedFatherAcceptMarriageWithoutQaima),
                            setState(() {
                              _selectedFatherAcceptMarriageWithoutQaima = item;
                            })
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب أن تحددي أحد الخيارات هنا';
                            }
                            return null;
                          },
                          hintText: 'هل يقبل ولي أمرك بالزواج الشرعي ؟',
                        ),
                        const SizedBox(height: 16),
                        SingleSelectionDropdown(
                          topText: 'هل أنت تقبلين بالزواج الشرعي ؟ ',
                          title: 'هل أنت تقبلين بالزواج الشرعي ؟ ',
                          items: youAcceptMarriageWithoutQaima.keys.toList(),
                          selectedItem:
                              _selectedYouAcceptMarriageWithoutQaima == true
                                  ? 'نعم'
                                  : _selectedYouAcceptMarriageWithoutQaima ==
                                          false
                                      ? 'لا'
                                      : null,
                          onSelected: (item) => {
                            _setDropdownChanged("you_accept", item,
                                _selectedFatherAcceptMarriageWithoutQaima),
                            setState(() {
                              _selectedYouAcceptMarriageWithoutQaima =
                                  item == "نعم" ? true : false;
                            })
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب أن تحددي أحد الخيارات هنا';
                            }
                            return null;
                          },
                          hintText: 'هل تقبلين بالزواج الشرعي ؟',
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPersonalInfoStep(BuildContext context) {
    final List<String> educationLevels = [
      'شهادة إبتدائية',
      'شهادة إعدادية',
      'شهادة ثانوية',
      'شهادة فني',
      'شهادة متوسطة',
      'شهادة بكالريوس',
      'شهادة ماجستير',
      'شهادة دكتوراه',
      'تعليم منزلي',
    ];

    // Validator for required fields
    String? _requiredFieldValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'هذا الحقل مطلوب';
      }
      return null;
    }

    return Form(
      key: _personalInfoFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              SingleSelectionDropdown(
                topText: 'الشهادة التعليمية',
                title: 'الشهادة التعليمية',
                items: educationLevels,
                selectedItem: _selectedEducationLevel,
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  _setDropdownChanged(
                      "education", item, _selectedEducationLevel);
                  setState(() {
                    _selectedEducationLevel = item;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر شهادتك التعليمية';
                  }
                  return null;
                },
                hintText: 'اختر شهادتك التعليمية',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: professionController,
                topText: 'الوظيفة/العمل',
                hintText: 'الوظيفة/العمل',
                keyboardType: TextInputType.text,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.work_outline_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 16),
              // About Me input with validation
              CustomTextField(
                controller: aboutMeController,
                topText: 'تكلم عن نفسك أو ما يقوله الناس عنك',
                hintText: 'تكلم عن نفسك أو ما يقوله الناس عنك',
                keyboardType: TextInputType.multiline,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.more_horiz_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: _requiredFieldValidator,
                maxLines: 5,
              ),

              const SizedBox(height: 16),
              // About my partner input with validation
              CustomTextField(
                controller: aboutMyPartnerController,
                topText: 'ما هي المواصفات التي تريدها في زوجك ؟',
                hintText: 'ما هي المواصفات التي تريدها في زوجك ؟',
                keyboardType: TextInputType.multiline,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.more_horiz_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: _requiredFieldValidator,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReligiousInfoStep(BuildContext context) {
    // Praying frequency options
    List<String> prayFrequencyOptionsStrings = [
      'كل الصلوات في المسجد',
      'معظم الصلوات في المسجد',
      'معظم الصلوات في البيت',
      'متقطع في الصلاة',
      'لا أصلي والعياذ بالله',
    ];
    if (_selectedGender == "F") {
      prayFrequencyOptionsStrings.removeRange(0, 2);
    }
    // Azkar practice options
    List<String> azkarPracticeOptionsStrings = [
      "دائمًا",
      "أحيانًا",
      "لا",
    ];

    Map<int, String> quranMemorizationChoices = {
      0: 'قصار السور',
      1: 'جزء واحد',
      2: 'جزءان',
      3: '3 أجزاء',
      4: '4 أجزاء',
      5: '5 أجزاء',
      6: '6 أجزاء',
      7: '7 أجزاء',
      8: '8 أجزاء',
      9: '9 أجزاء',
      10: '10 أجزاء',
      11: '11 جزءًا',
      12: '12 جزءًا',
      13: '13 جزءًا',
      14: '14 جزءًا',
      15: '15 جزءًا',
      16: '16 جزءًا',
      17: '17 جزءًا',
      18: '18 جزءًا',
      19: '19 جزءًا',
      20: '20 جزءًا',
      21: '21 جزءًا',
      22: '22 جزءًا',
      23: '23 جزءًا',
      24: '24 جزءًا',
      25: '25 جزءًا',
      26: '26 جزءًا',
      27: '27 جزءًا',
      28: '28 جزءًا',
      29: '29 جزءًا',
      30: '30 جزءًا',
    };

    // Validators
    String? _requiredFieldValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'هذا الحقل مطلوب';
      }
      return null;
    }

    return Form(
      key: _religiousInfoFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Memorized Quran Parts input with validation
              SingleSelectionDropdown(
                topText: 'أجزاء القرآن المحفوظة',
                title: 'أجزاء القرآن المحفوظة',
                items: quranMemorizationChoices.keys
                    .map((item) => item.toString())
                    .toList(),
                selectedItem: quranMemorizationChoices[_selectedQuranParts],
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  _setDropdownChanged("quran", item, _selectedQuranParts);
                  setState(() {
                    _selectedQuranParts = int.tryParse(item!);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر اجابة محددة';
                  }
                  return null;
                },
                hintText: 'حفظ القرآن',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: relationWithFamilyController,
                topText: 'كيف هي علاقتك مع أهلك وأسرتك ؟',
                hintText: 'كيف هي علاقتك مع أهلك وأسرتك ؟',
                keyboardType: TextInputType.text,
                preIconPadding: 11,
                prefixIcon: const Icon(Icons.people_outline_outlined),
                validator: _requiredFieldValidator,
              ),
              const SizedBox(height: 16),
              SingleSelectionDropdown(
                topText: 'كيف أنت مع الصلاة ؟',
                title: 'كيف أنت مع الصلاة ؟',
                items: prayFrequencyOptionsStrings,
                selectedItem: _selectedPrayFrequency,
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  _setDropdownChanged("pray", item, _selectedPrayFrequency);
                  setState(() {
                    _selectedPrayFrequency = item;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر اجابة محددة';
                  }
                  return null;
                },
                hintText: 'الصلاة',
              ),
              const SizedBox(height: 16),
              SingleSelectionDropdown(
                topText: 'هل تحافظ على أذكار الصباح والمساء ؟',
                title: 'هل تحافظ على أذكار الصباح والمساء ؟',
                items: azkarPracticeOptionsStrings,
                selectedItem: _selectedAzkarPractice,
                // Optional: set an initial selected item
                onSelected: (String? item) {
                  _setDropdownChanged("azkar", item, _selectedAzkarPractice);
                  setState(() {
                    _selectedAzkarPractice = item;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'من فضلك اختر اجابة محددة';
                  }
                  return null;
                },
                hintText: 'الأذكار',
              ),

              const SizedBox(height: 16),
              // Text(_selectedLe7ya!),
              if (_selectedGender != null && _selectedGender == "M")
                SingleSelectionDropdown(
                  topText: 'شكل الوجه',
                  title: 'شكل الوجه',
                  items: const ["ملتحي", "لحية خفيفة", "أملس"],
                  selectedItem:
                      (_selectedLe7ya == null || _selectedLe7ya!.isEmpty)
                          ? null
                          : _selectedLe7ya,
                  // Optional: set an initial selected item
                  onSelected: (String? item) {
                    _setDropdownChanged("le7ya", item, _selectedLe7ya);
                    setState(() {
                      _selectedLe7ya = item;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك اختر خيارا محددا';
                    }
                    return null;
                  },
                  hintText: 'شكل الوجه',
                )
              else if (_selectedGender != null && _selectedGender == "F")
                SingleSelectionDropdown(
                  title: 'شكل الحجاب',
                  items: const [
                    "منتقبة سواد",
                    "منتقبة ألوان",
                    "مختمرة",
                    "طرح وفساتين",
                    "طرح وبناطيل",
                    "غير محجبة",
                  ],
                  selectedItem:
                      (_selectedHijab == null || _selectedHijab!.isEmpty)
                          ? null
                          : _selectedHijab,
                  // Optional: set an initial selected item
                  onSelected: (String? item) {
                    _setDropdownChanged("hijab", item, _selectedHijab);
                    setState(() {
                      _selectedHijab = item;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك اختر خيارا محددا';
                    }
                    return null;
                  },
                  hintText: 'شكل الحجاب',
                ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: hobbiesController,
                topText: 'كيف تقضي وقتك أو ما هي هواياتك ؟',
                hintText: '...',
                keyboardType: TextInputType.multiline,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.hourglass_bottom_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: _requiredFieldValidator,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: disabilitiesController,
                topText: 'هل تعاني من أي أمراض أو إعاقات ؟',
                hintText: '...',
                keyboardType: TextInputType.text,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.sick_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: _requiredFieldValidator,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: whoListenToController,
                topText: 'لمن تسمع من المشايخ/الدعاة/العلماء ؟',
                hintText: '...',
                keyboardType: TextInputType.multiline,
                preIconPadding: 11,
                prefixIcon: Icon(
                  Icons.hearing_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                validator: _requiredFieldValidator,
                maxLines: 3,
              ),


            ],
          ),
        ),
      ),
    );
  }
}
