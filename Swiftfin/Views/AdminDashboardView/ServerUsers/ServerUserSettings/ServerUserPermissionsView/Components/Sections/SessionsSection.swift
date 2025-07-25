//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2025 Jellyfin & Jellyfin Contributors
//

import JellyfinAPI
import SwiftUI

extension ServerUserPermissionsView {

    struct SessionsSection: View {

        @Binding
        var policy: UserPolicy

        // MARK: - Body

        var body: some View {
            FailedLoginsView
            MaxSessionsView
        }

        // MARK: - Failed Login Selection View

        @ViewBuilder
        private var FailedLoginsView: some View {
            Section {
                CaseIterablePicker(
                    L10n.maximumFailedLoginPolicy,
                    selection: $policy.loginAttemptsBeforeLockout
                        .coalesce(0)
                        .map(
                            getter: { LoginFailurePolicy(rawValue: $0) ?? .custom },
                            setter: { $0.rawValue }
                        )
                )

                if let loginAttempts = policy.loginAttemptsBeforeLockout, loginAttempts > 0 {
                    MaxFailedLoginsButton()
                }

            } header: {
                Text(L10n.sessions)
            } footer: {
                VStack(alignment: .leading) {
                    Text(L10n.maximumFailedLoginPolicyDescription)

                    LearnMoreButton(L10n.maximumFailedLoginPolicy) {
                        LabeledContent(
                            L10n.lockedUsers,
                            value: L10n.maximumFailedLoginPolicyReenable
                        )
                        LabeledContent(
                            L10n.unlimited,
                            value: L10n.unlimitedFailedLoginDescription
                        )
                        LabeledContent(
                            L10n.default,
                            value: L10n.defaultFailedLoginDescription
                        )
                        LabeledContent(
                            L10n.custom,
                            value: L10n.customFailedLoginDescription
                        )
                    }
                }
            }
        }

        // MARK: - Failed Login Selection Button

        @ViewBuilder
        private func MaxFailedLoginsButton() -> some View {
            ChevronButton(
                L10n.customFailedLogins,
                subtitle: Text(policy.loginAttemptsBeforeLockout ?? 1, format: .number),
                description: L10n.enterCustomFailedLogins
            ) {
                TextField(
                    L10n.failedLogins,
                    value: $policy.loginAttemptsBeforeLockout
                        .coalesce(1)
                        .clamp(min: 1, max: 1000),
                    format: .number
                )
                .keyboardType(.numberPad)
            }
        }

        // MARK: - Failed Login Validation

        @ViewBuilder
        private var MaxSessionsView: some View {
            Section {
                CaseIterablePicker(
                    L10n.maximumSessionsPolicy,
                    selection: $policy.maxActiveSessions.map(
                        getter: { ActiveSessionsPolicy(rawValue: $0) ?? .custom },
                        setter: { $0.rawValue }
                    )
                )

                if policy.maxActiveSessions != ActiveSessionsPolicy.unlimited.rawValue {
                    MaxSessionsButton()
                }

            } footer: {
                VStack(alignment: .leading) {
                    Text(L10n.maximumConnectionsDescription)

                    LearnMoreButton(L10n.maximumSessionsPolicy) {
                        LabeledContent(
                            L10n.unlimited,
                            value: L10n.unlimitedConnectionsDescription
                        )
                        LabeledContent(
                            L10n.custom,
                            value: L10n.customConnectionsDescription
                        )
                    }
                }
            }
        }

        @ViewBuilder
        private func MaxSessionsButton() -> some View {
            ChevronButton(
                L10n.customSessions,
                subtitle: Text(policy.maxActiveSessions ?? 1, format: .number),
                description: L10n.enterCustomMaxSessions
            ) {
                TextField(
                    L10n.maximumSessions,
                    value: $policy.maxActiveSessions
                        .coalesce(1)
                        .clamp(min: 1, max: 1000),
                    format: .number
                )
                .keyboardType(.numberPad)
            }
        }
    }
}
