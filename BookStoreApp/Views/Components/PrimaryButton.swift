//
// PrimaryButton.swift
// BookstoreApp
//

import SwiftUI

/// Full-width styled primary action button with optional leading/trailing icon and loading state.
struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var trailingIcon: String? = nil
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var style: PrimaryButtonStyle = .filled
    let action: () -> Void

    var body: some View {
        Button(action: {
            guard !isLoading && !isDisabled else { return }
            action()
        }) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: labelColor))
                        .scaleEffect(0.85)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(AppFonts.button)
                    if let trailing = trailingIcon {
                        Image(systemName: trailing)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .foregroundColor(labelColor)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(backgroundFill)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isDisabled)
        .animation(.easeInOut(duration: 0.15), value: isLoading)
    }

    // MARK: Styling helpers

    private var labelColor: Color {
        switch style {
        case .filled:  return .white
        case .outline: return AppColors.primary
        case .ghost:   return AppColors.primary
        }
    }

    @ViewBuilder
    private var backgroundFill: some View {
        switch style {
        case .filled:
            AppColors.primary
        case .outline, .ghost:
            Color.clear
        }
    }

    private var borderColor: Color {
        switch style {
        case .filled:  return Color.clear
        case .outline: return AppColors.primary
        case .ghost:   return Color.clear
        }
    }

    private var borderWidth: CGFloat { style == .outline ? 1.5 : 0 }
}

// MARK: - Style Enum

enum PrimaryButtonStyle {
    case filled
    case outline
    case ghost
}

// MARK: - Preview

#if DEBUG
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.md) {
            PrimaryButton(title: "Add to Cart", icon: "bag.badge.plus", style: .filled) {}
            PrimaryButton(title: "View All Books", trailingIcon: "arrow.right", style: .outline) {}
            PrimaryButton(title: "Loading…", isLoading: true, style: .filled) {}
            PrimaryButton(title: "Out of Stock", isDisabled: true, style: .filled) {}
            PrimaryButton(title: "Learn More", style: .ghost) {}
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
