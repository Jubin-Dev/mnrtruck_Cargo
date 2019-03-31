import 'dart:async';
import 'package:m_n_r/src/models/pregateinmodel.dart';
import 'package:m_n_r/src/models/surveymodel.dart';
//import 'package:m_n_r/src/models/mastermodel.dart';

class Validators
{
  final validateEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (email, sink) {
      //if (email.contains('@')) 
      if (email.isNotEmpty) 
        {
          sink.add(email);
        }
        else
        {
          sink.addError('Enter a Valid User. !');
        }
    });
  
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (pwd, sink) {
      if (pwd.length > 2)
      {
        sink.add(pwd);
      }
      else
      {
        sink.addError('Pwd atleast 4 chars.');
      }
    }

  );

  // For Branch code and Yard code validation
  final validateCode = StreamTransformer<String, String>.fromHandlers(
    handleData: (code, sink) {
      if (code.isNotEmpty)
      {
        sink.add(code);
      }
      else
      {
        sink.addError('Select Code.');
      }
    }
  );

  // Validating Pre Gate In Screen
  final validateContNo = StreamTransformer<String,String>.fromHandlers(
  handleData: (contNo, sink) {
    if (contNo.isNotEmpty) 
      {
        sink.add(contNo);
      }
      else
      {
        sink.addError('Invalid Container No. !');
      }
  });

  // Validating Pre Gate In details Screen
  final validatePreGInDtls = StreamTransformer<List<PreGateInDt>, List<PreGateInDt>>.fromHandlers(
  handleData: (pGIDetails, sink) {
    if (pGIDetails.isNotEmpty) 
      {
        sink.add(pGIDetails);
      }
      else
      {
        sink.addError('Invalid Container No. !');
      }
  });

  // Validating Pre Gate In details Screen
  final validateSurveyDtls = StreamTransformer<List<SurveyDetails>, List<SurveyDetails>>.fromHandlers(
  handleData: (surDtls, sink) {
    if (surDtls.isNotEmpty) 
      {
        sink.add(surDtls);
      }
      else
      {
        sink.addError('Invalid Container No. !');
      }
  });

    // Validating Pre Gate In Screen
  final validateLookUps = StreamTransformer<List<LookupItem>, List<LookupItem>>.fromHandlers(
  handleData: (lookUpitems, sink) {
    if (lookUpitems.isNotEmpty) 
      {
        sink.add(lookUpitems);
      }
      else
      {
        sink.addError('Invalid Look Up Details !');
      }
  });

  // Validating Pre Gate In Screen
  final validatedropDown = StreamTransformer<String,String>.fromHandlers(
  handleData: (dpvalue, sink) {
    //sink.add(dpvalue);
    if (dpvalue.isNotEmpty) 
        {
          sink.add(dpvalue);
        }
        else
        {
          sink.addError('Select Data !');
          //sink.addError(Stream.empty());
        }
  });

    // Validating Pre Gate In Screen
  final validateBranchCode = StreamTransformer<String,String>.fromHandlers(
  handleData: (dpvalue, sink) {
    //sink.add(dpvalue);
    if (dpvalue.isNotEmpty) 
        {
          sink.add(dpvalue);
        }
        else
        {
          sink.addError('Select Data !');
          //sink.addError(Stream.empty());
        }
  });

  // Validate all the common Text fields
  final validateTxtFld = StreamTransformer<String,String>.fromHandlers(
  handleData: (txtFld, sink) {
    if (txtFld.isNotEmpty) 
      {
        sink.add(txtFld);
      }
      else
      {
        sink.addError('Enter data.');
        //sink.addError(Stream.empty());
      }
  });

}

