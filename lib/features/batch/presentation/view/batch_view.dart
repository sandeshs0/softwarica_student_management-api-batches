import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/core/common/snackbar/my_snackbar.dart';
import 'package:softwarica_student_management_bloc/features/batch/presentation/view_model/batch_bloc.dart';

class BatchView extends StatelessWidget {
  BatchView({super.key});

  final batchNameController = TextEditingController();
  final _batchViewFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<BatchBloc, BatchState>(
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          showMySnackBar(
            context: context,
            message: state.error!,
            color: Colors.red,
          );
        }
        // Additional listener handling for other states if necessary
      },
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _batchViewFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: batchNameController,
                  decoration: const InputDecoration(
                    labelText: 'Batch Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter batch name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_batchViewFormKey.currentState!.validate()) {
                      context.read<BatchBloc>().add(
                            AddBatch(batchNameController.text),
                          );
                    }
                  },
                  child: Text('Add Batch'),
                ),
                SizedBox(height: 10),
                BlocBuilder<BatchBloc, BatchState>(
                  builder: (context, state) {
                    if (state.batches.isEmpty) {
                      return Center(child: Text('No Batches Added Yet'));
                    } else if (state.isLoading) {
                      return CircularProgressIndicator();
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.batches.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(state.batches[index].batchName),
                              subtitle: Text(state.batches[index].batchId!),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  context.read<BatchBloc>().add(
                                        DeleteBatch(
                                            state.batches[index].batchId!),
                                      );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
