import 'package:flutter/material.dart';
import 'package:letaskono_flutter/features/auth/presentation/widgets/gender_selection_widget.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentStep = 0;

  // Form keys for each step
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _familyInfoFormKey = GlobalKey<FormState>();
  final _religiousInfoFormKey = GlobalKey<FormState>();

  // Form controllers
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    heightController.dispose();
    ageController.dispose();
    weightController.dispose();
    cityController.dispose();
    countryController.dispose();
    phoneController.dispose();
    aboutMeController.dispose();
    super.dispose();
  }

  void nextPage() {
    // Validate based on the current step
    bool isValid = false;
    switch (_currentStep) {
      case 0:
        isValid = _basicInfoFormKey.currentState!.validate();
        break;
      case 1:
        isValid = _locationFormKey.currentState!.validate();
        break;
      case 2:
        isValid = _personalInfoFormKey.currentState!.validate();
        break;
      case 3:
        isValid = _familyInfoFormKey.currentState!.validate();
        break;
      case 4:
        isValid = _religiousInfoFormKey.currentState!.validate();
        break;
      default:
        isValid = true;
    }

    if (isValid) {
      if (_currentStep < 5) {
        _controller.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    }
  }

  void previousPage() {
    if (_currentStep > 0) {
      _controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: Column(
        children: [
          // Horizontal step indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return CircleAvatar(
                radius: 20,
                backgroundColor:
                    _currentStep == index ? Colors.blue : Colors.grey,
                child: Text('${index + 1}'),
              );
            }),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              onPageChanged: (page) {
                setState(() {
                  _currentStep = page;
                });
              },
              children: [
                buildBasicInfoStep(context),
                buildLocationStep(context),
                buildPersonalInfoStep(context),
                buildFamilyInfoStep(context),
                buildReligiousInfoStep(context),
                buildDocumentUploadStep(context),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                      onPressed: previousPage, child: const Text('Previous')),
                ElevatedButton(
                    onPressed: nextPage,
                    child: Text(_currentStep == 5 ? 'Finish' : 'Next')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: Basic Information
  Widget buildBasicInfoStep(BuildContext context) {
    String? selectedGender;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _basicInfoFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GenderSelectionWidget(
                onGenderSelected: (gender) {
                  selectedGender = gender;
                },
              ),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Age must be greater than 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: heightController,
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                decoration: const InputDecoration(labelText: 'Height'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Step 2: Location Information
  Widget buildLocationStep(BuildContext context) {
    return Form(
      key: _locationFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
      ),
    );
  }

  // Step 3: Personal Information
  Widget buildPersonalInfoStep(BuildContext context) {
    return Form(
      key: _personalInfoFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Profession'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Marital Status'),
            ),
            TextField(
              controller: aboutMeController,
              decoration: const InputDecoration(labelText: 'About Me'),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  // Step 4: Family Information
  Widget buildFamilyInfoStep(BuildContext context) {
    return Form(
      key: _familyInfoFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchListTile(
              title: const Text('Father Alive'),
              value: true, // Replace with actual value from state management
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Mother Alive'),
              value: true, // Replace with actual value from state management
              onChanged: (value) {},
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Number of Brothers'),
              keyboardType: TextInputType.number,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Number of Sisters'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  // Step 5: Religious Information
  Widget buildReligiousInfoStep(BuildContext context) {
    return Form(
      key: _religiousInfoFormKey,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Memorized Quran Parts'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Relation with Family'),
            ),
          ],
        ),
      ),
    );
  }

  // Step 6: Document Upload
  Widget buildDocumentUploadStep(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              // Trigger file picker for national ID front
            },
            child: const Text('Upload National ID Front'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Trigger file picker for national ID back
            },
            child: const Text('Upload National ID Back'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Trigger file picker for holding ID photo
            },
            child: const Text('Upload ID Holding Photo'),
          ),
        ],
      ),
    );
  }
}
