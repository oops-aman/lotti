import 'dart:async';
import 'dart:io';

import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/foundation.dart';
import 'package:lotti/classes/config.dart';
import 'package:lotti/database/logging_db.dart';
import 'package:lotti/get_it.dart';
import 'package:lotti/sync/imap_client.dart';

Future<GenericImapResult> saveImapMessage({
  File? file,
  required SyncConfig syncConfig,
  required ImapClient imapClient,
  required String subject,
  required String encryptedMessage,
}) async {
  final loggingDb = getIt<LoggingDb>();

  try {
    final inbox = await imapClient.selectMailboxByPath(
      syncConfig.imapConfig.folder,
    );

    final builder = MessageBuilder.prepareMultipartAlternativeMessage()
      ..subject = subject
      ..addTextPlain(encryptedMessage);

    if (file != null) {
      final fileLength = file.lengthSync();
      if (fileLength > 0) {
        await builder.addFile(
          file,
          MediaType.fromText('application/octet-stream'),
        );
      }
    }

    final message = builder.buildMimeMessage();
    final res = await imapClient.appendMessage(
      message,
      targetMailbox: inbox,
      flags: [r'\Seen'],
    );
    debugPrint(
      'saveImapMessage responseCode ${res.responseCode} details ${res.details}',
    );
    return res;
  } catch (exception, stackTrace) {
    loggingDb.captureException(
      exception,
      domain: 'OUTBOX_IMAP',
      subDomain: 'saveImapMessage',
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

const String sharedSecretKey = 'sharedSecret';
const String imapConfigKey = 'imapConfig';
const String lastReadUidKey = 'lastReadUid';

Future<ImapClient?> persistImap({
  required String encryptedMessage,
  required String subject,
  required SyncConfig syncConfig,
  required bool allowInvalidCert,
  String? encryptedFilePath,
  ImapClient? prevImapClient,
}) async {
  final loggingDb = getIt<LoggingDb>();

  ImapClient? imapClient;
  try {
    if (prevImapClient != null && prevImapClient.isConnected) {
      imapClient = prevImapClient;
    } else {
      await prevImapClient?.disconnect();
      imapClient = await createImapClient(syncConfig, allowInvalidCert: allowInvalidCert,);
    }

    GenericImapResult? res;
    if (imapClient != null) {
      if (encryptedFilePath != null && encryptedFilePath.isNotEmpty) {
        final encryptedFile = File(encryptedFilePath);
        final fileLength = encryptedFile.lengthSync();
        if (fileLength > 0) {
          res = await saveImapMessage(
            imapClient: imapClient,
            subject: subject,
            encryptedMessage: encryptedMessage,
            syncConfig: syncConfig,
            file: encryptedFile,
          );
        }
      } else {
        res = await saveImapMessage(
          imapClient: imapClient,
          subject: subject,
          encryptedMessage: encryptedMessage,
          syncConfig: syncConfig,
        );
      }
    }

    final resDetails = res?.details;
    loggingDb.captureEvent(
      resDetails ?? 'no result details',
      domain: 'OUTBOX_IMAP',
    );

    if (resDetails != null && resDetails.contains('completed')) {
      return imapClient;
    } else {
      await imapClient?.disconnect();
      return null;
    }
  } catch (exception, stackTrace) {
    loggingDb.captureException(
      exception,
      domain: 'OUTBOX_IMAP persistImap',
      stackTrace: stackTrace,
    );
    await prevImapClient?.disconnect();
    imapClient = null;
    rethrow;
  }
}