// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:konata/models/qna_api_models.dart';
import 'package:konata/utils/api_utils.dart';
import 'package:konata/utils/variable.dart';

class QnAController extends GetxController {
  final isLoading = true.obs;
  final question = QnAResponse().obs;
  final isEnd = false.obs;

  final isConfirmAnswer = false.obs; //音声入力の設問の結果確認用
  final numberAnswerValue = "".obs; //音声入力の値

  final isFirst = true.obs;
  final questionIndex = 0.obs;

  Future<void> init() async {
    try {
      await getQuestion();
    } catch (e) {
      print(e);
    }
  }

  getQuestion() async {
    try {
      isEnd.value = false;
      isLoading.value = true;
      isConfirmAnswer.value = false;
      await Future.delayed(const Duration(seconds: 1));
      question.value = await questionGet(
          QuestionRequest(
            aivo_id: selectUser.aivo_id,
            parent_id: selectUser.parent_id,
            session_id: session_id,
          ),
          questionIndex: questionIndex.value);

      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

  ///設問回答<br>
  ///次の設問が[normal] =>繰り返し
  answer(int index, {bool numberAnswer = false}) async {
    try {
      isEnd.value = false;
      isLoading.value = true;
      isConfirmAnswer.value = numberAnswer;
      await Future.delayed(const Duration(seconds: 1));
      var answerResponse = await questionAns(
          AnswerRequest(
              aivo_id: selectUser.aivo_id,
              parent_id: selectUser.parent_id,
              session_id: session_id,
              answers: Answer(
                question_id: question.value.questions!.id,
                question_type: questionType(),
                answer: !numberAnswer ? itemValue(index) : numberAnswerValue.value,
              )),
          questionIndex: questionIndex.value);

      if (answerResponse.toNext()) {
        questionIndex.value = questionIndex.value + 1;
        await getQuestion();
        isFirst.value = false;
        isConfirmAnswer.value = false;
        return;
      }
      if (answerResponse.isFinish()) {
        isEnd.value = true;
      }
      isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

  answerNumber() async {
    await answer(0, numberAnswer: true);
  }

  ///音声入力の質問の確認（中間ステップ）<br>
  ///value: 音声入力値
  confirmAnswer(String value) {
    isConfirmAnswer.value = true;
    numberAnswerValue.value = value;
    question.value.message = value;
  }

  reAnswer() {
    isConfirmAnswer.value = false;
    question.value.message = null;
  }

  questionTitle() => question.value.questions?.content!.question_title!;
  questionType() => question.value.questions?.type!;
  answerCount() => question.value.questions?.content!.items!.length;
  itemTitle(index) => question.value.questions?.content!.items![index].item_title;
  itemValue(index) => question.value.questions?.content!.items![index].item_id;
}
