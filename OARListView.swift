import SwiftUI

struct OARListView: View {
    @ObservedObject var vm: CalculatorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 0) {
                HeaderCell("OAR",          flex: 3)
                HeaderCell("Limit\nEQD2",  flex: 1)
                HeaderCell("C1 Red%",      flex: 1)
                HeaderCell("C2 Red%",      flex: 1)
                HeaderCell("Allowed\nEQD2",flex: 1)
                HeaderCell("C1\nEQD2",     flex: 1)
                HeaderCell("C2\nEQD2",     flex: 1)
                HeaderCell("SUM",          flex: 1)
                HeaderCell("Status",       flex: 1)
            }
            .background(Color(hex: "2E4057"))

            // Rows
            ForEach(Array(OAR_DATA.enumerated()), id: \.offset) { idx, oar in
                let result = vm.oarResult(for: idx)
                let isSelected = vm.selectedOARIndex == idx
                let c1Red = vm.c1ReductionOn ? oar.reduction[vm.c1TimeIndex] : 0
                let c2Red = vm.c2ReductionOn ? oar.reduction[vm.c2TimeIndex] : 0

                HStack(spacing: 0) {
                    // OAR name
                    Text(oar.name)
                        .font(.caption2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                        .frame(minWidth: 0)
                        .layoutPriority(3)

                    DataCell(oar.limit.map { String(format: "%.0f", $0) } ?? "—")
                    DataCell(oar.limit != nil ? "\(c1Red)%" : "—")
                    DataCell(oar.limit != nil ? "\(c2Red)%" : "—")

                    // Allowed EQD2
                    if let allowed = result.allowed {
                        Text(String(format: "%.2f", allowed))
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(2)
                            .background(allowed >= 0 ? Color(hex: "3b7dd4") : Color(hex: "dc3232"))
                    } else {
                        Text("—")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(2)
                            .background(Color(hex: "3b7dd4"))
                    }

                    DataCell(String(format: "%.2f", result.c1EQD2))
                    DataCell(String(format: "%.2f", result.c2EQD2))
                    DataCell(String(format: "%.2f", result.sum))

                    // Status
                    Text(result.status.label)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(result.status == .violation ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(2)
                        .background(statusColor(result.status))
                        .layoutPriority(1)
                }
                .background(isSelected ? Color(hex: "b4dcff").opacity(0.3) : (idx % 2 == 0 ? Color.clear : Color.white.opacity(0.03)))
                .onTapGesture {
                    vm.selectedOARIndex = idx
                }

                Divider().background(Color.gray.opacity(0.3))
            }
        }
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }

    func statusColor(_ s: OARStatus) -> Color {
        switch s {
        case .ok:        return Color(hex: "64dc64")
        case .violation: return Color(hex: "ff5050")
        case .review:    return Color(hex: "ffdc32")
        }
    }
}

struct HeaderCell: View {
    let text: String
    let flex: Int
    init(_ text: String, flex: Int = 1) { self.text = text; self.flex = flex }

    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .layoutPriority(Double(flex))
    }
}

struct DataCell: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.caption2)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(2)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >>  8) & 0xFF) / 255
        let b = Double((int      ) & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
